class BookController < ApplicationController
  skip_before_action :verify_authenticity_token, :only => :create

  def index
    @client = Client.new
    @reservation = Reservation.new(client: @client)
  end

  def create
    begin
    ActiveRecord::Base.transaction do
      @client = Client.find_by(client_params) || Client.new(client_params)
      @reservation = Reservation.new(reservation_params)
      @room = Room.find_by(type_of_room: type_of_room.downcase)
      @reservation.client = @client
      @reservation.room = @room

      calculate_reservation_room

      if @reservation.valid? && @client.valid?
        @client.save!
        @reservation.save!
        # ClientMailer.with(reservation: @reservation).welcome_email.deliver_now
        render :json => { :text => payment }
      else
        @client.valid?
        render :json => { :text => errors }, :status => 500
        raise ActiveRecord::Rollback, "Rolling back"
      end
    end
    rescue ActiveRecord::RecordInvalid
      render :json => { :text => "У нас не осталось мест на эти даты" }, :status => 500
    rescue => ex
      render :json => { :text => ex }, :status => 500
    end
  end

  def update
    create
  end

  private

  def payment
    liqpay = Liqpay.new
    liq = liqpay.cnb_form({
                        action:      "pay",
                        amount:      @reservation.prepayment,
                        currency:    "UAH",
                        description: "Предоплата за номер " + @room.type_of_room_ru,
                        email:       @reservation.email,
                        order_id:    @reservation.id,
                        version:     "3"
                    })
    doc =  Nokogiri.HTML(liq)
    doc.css('input').last.replace("<button style=\"border: none !important; display:inline-block !important;text-align: center !important;padding: 7px 20px !important; color: #fff !important; font-size:16px !important; font-weight: 600 !important; font-family:OpenSans, sans-serif; cursor: pointer !important; border-radius: 2px !important; background: #3ab0ff !important;\"onmouseover=\"this.style.opacity='0.5';\" onmouseout=\"this.style.opacity='1';\"> <img src=\"https://static.liqpay.ua/buttons/logo-small.png\" name=\"btn_text\" style=\"margin-right: 7px !important; vertical-align: middle !important;\"/> <span style=\"vertical-align:middle; !important\">Сделать предоплату #{@reservation.prepayment} UAH</span> </button>")
    doc.to_html
  end

  def calculate_reservation_room
    date_from = @reservation.date_from
    date_to = @reservation.date_to
    price = 0
    if date_from.present? && date_to.present?
      sd = Date.parse(date_from.to_s)
      ed = Date.parse(date_to.to_s)
      sd.upto(ed).each do |date|
        room_date = RoomDate.find_by(date: date, room: @room)
        next if room_date.nil?
        room_date.number = room_date.number - 1
        room_date.reservations << @reservation
        room_date.save!
        price += room_date.price
      end
    end
    @reservation.total_price = price
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
