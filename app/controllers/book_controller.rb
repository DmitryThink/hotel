class BookController < BaseController
  skip_before_action :verify_authenticity_token, :only => [:create, :payment]
  before_action :click, only:[:index]
  include Concurrent::Async

  def index; end

  def create
    begin
      ActiveRecord::Base.transaction do
        @client = Client.find_by(client_params) || Client.new(client_params)
        @reservation = Reservation.new(reservation_params)
        @reservation.update_year_of_system
        @room = Room.find_by(type_of_room: type_of_room.downcase)
        @reservation.client = @client
        @reservation.room = @room

        @reservation.calculate_total_price

        if @reservation.valid? && @client.valid?
          @client.save!
          @reservation.save!
          render :json => { :text => payment_button, :price => @reservation.total_price }
        else
          @client.valid?
          render :json => { :text => errors }, :status => 500
          raise ActiveRecord::Rollback, "Rolling back"
        end
      end
    rescue => ex
      render :json => { :text => "Что-то пошло не так..." }, :status => 500
    end
  end

  def update
    create
  end

  def payment
    liqpay = Liqpay.new
    data      = request.parameters['data']
    signature = request.parameters['signature']

    if liqpay.match?(data, signature)
      responce_hash = liqpay.decode_data(data)
      # Check responce_hash['status'] and process due to Liqpay API documentation.
      if responce_hash['status'] == "success"
        @reservation = Reservation.find(responce_hash['order_id'])
        ActiveRecord::Base.transaction do
          ClientMailer.with(reservation: @reservation).welcome_email.deliver_now
          @reservation.update!(prepaid: true)
        end
        render :payment
      end
    end
  end

  def api_request
    liqpay = Liqpay.new
    liqpay.api('request', {
        action:      "invoice_send",
        amount:      1,#@reservation.prepayment,
        currency:    "UAH",
        description: "Предоплата за номер " + @room.type_of_room_ru + ". Оплатить нужно до: " + (Time.now + 40.minute).strftime('%Y-%m-%d %H:%M:%S') + " по Киеву",
        email:       @reservation.email,
        order_id:    @reservation.id,
        expired_date: (Time.now.utc + 40.minute).strftime('%Y-%m-%d %H:%M:%S'),
        version:     "3"
    })
  end

  private

  def payment_button
    liqpay = Liqpay.new
    self.async.api_request
    liq = liqpay.cnb_form({
                        action:      "pay",
                        amount:      1,#@reservation.prepayment,
                        currency:    "UAH",
                        description: "Предоплата за номер " + @room.type_of_room_ru + ". Оплатить нужно до: " + (Time.now + 40.minute).strftime('%Y-%m-%d %H:%M:%S') + " по Киеву",
                        email:       @reservation.email,
                        order_id:    @reservation.id,
                        expired_date: (Time.now.utc + 40.minute).strftime('%Y-%m-%d %H:%M:%S'),
                        version:     "3"
                    })
    doc = Nokogiri.HTML(liq)
    doc.css('input').last.replace("<button style=\"border: none !important; display:inline-block !important;text-align: center !important;padding: 7px 40px 7px 20px !important; color: #fff !important; font-size:20px !important; font-weight: 600 !important; font-family:OpenSans, sans-serif; cursor: pointer !important; border-radius: 2px !important; background: #3ab0ff !important;\"onmouseover=\"this.style.opacity='0.5';\" onmouseout=\"this.style.opacity='1';\"> <img scr=\"https://static.liqpay.ua/buttons/logo-small.png\" name=\"btn_text\" style=\"margin-right: 7px !important; vertical-align: middle !important;\"/> <span style=\"vertical-align:middle; !important\">Сделать предоплату #{@reservation.prepayment} UAH</span> </button>")
    doc.to_html
  end

  def errors
    errors = ""
    @reservation.errors.full_messages.each do |error|
      errors += error.to_s + '; '
    end
    @client.errors.full_messages.each do |error|
      errors += error.to_s + '; '
    end
    errors
  end

  def reservation_params
    params.require(:reservation).permit(:date_from, :date_to, :message)
  end

  def client_params
    prms = params.require(:client).permit(:name, :surname, :phone_number, :email)
    prms[:email] = prms[:email].downcase
    prms[:phone_number] = prms[:phone_number].gsub!(/[\-|\)|\(| ]/, '') || prms[:phone_number]
    prms[:phone_number] = prms[:phone_number][2..-1] if prms[:phone_number][0..2] == "380"
    prms[:phone_number] = prms[:phone_number][3..-1] if prms[:phone_number][0..3] == "+380"
    prms[:name] = capitalize(prms[:name])
    prms[:surname] = capitalize(prms[:surname])
    prms
  end

  def capitalize(str)
    str[0].mb_chars.upcase.to_s + str[1..-1]
  end

  def type_of_room
    params[:type_of_room]
  end
end
