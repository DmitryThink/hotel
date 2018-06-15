class BookController < ApplicationController
  def index
    @client = Client.new(person: Person.new)
  end

  def create
    if params[:reservation].present?
      @reservation = Reservation.new(reservation_params)
      @client = Client.find(@reservation.client_id)
      case @reservation.step
        when "choose_date"
          choose_date
        when "choose_payment"
          choose_payment
        when "payment"
          payment
        when "pre_payment"
          prepayment
        else
          @reservation.room = Room.new
          @reservation.step = "choose_date"
          render :choose_date
      end
    else
      @client = Client.new(client_params)
      @client.person = Person.new(person_params)
      if Client.find_by(phone_number: client_params[:phone_number])
        client = Client.find_by(phone_number: client_params[:phone_number])
        if client.name == person_params[:name] && client.surname == person_params[:surname]
          @client = client
        end
      end
      if @client.valid? || @client.person.valid?
        @client.save!
        @reservation = Reservation.new(room: Room.new, client: @client)
        @reservation.step = "choose_date"
        render :choose_date
      else
        render :index
      end
    end
  end

  def update
    create
  end

  def show
    prepayment
  end

  def choose_date
    if Room.free_rooms?(type_of_room, date_from, date_to)
      @reservation = Reservation.new(date_from: date_from,
                                         date_to: date_to,
                                         client: @reservation.client,
                                         room: Room.free_rooms(type_of_room, date_from, date_to).first)
      if @reservation.valid?
        @reservation.total_price = @reservation.calculate_total_price
        @reservation.step = "choose_payment"
        render :choose_payment
      else
        render :choose_date
      end
    else
      @reservation = Reservation.new(room: Room.new, client: @reservation.client, step: "choose_date")
      @reservation.errors.add(:base, "We haven't #{type_of_room} rooms with this dates!")
      byebug
      render :choose_date
    end
  end

  def choose_payment
    @reservation.payment = payment_params[:payment]
    if @reservation.valid?
      if payment_params[:payment] == "card"
        @reservation.step = "payment"
        render :payment
      else
        @reservation.save!
        @reservation.step = "pre_payment"
        render :prepayment
      end
    else
      render :choose_payment
    end
  end

  def payment
    @reservation.save!
    @reservations = @reservation.client.reservations
    render :succeed
  end

  def prepayment
    @reservation = Reservation.find(params[:id] || params[:reservation][:id])
    if @reservation.paid
      @reservation.save!
      render :succeed
    else
      @reservation.errors.add(:base, "Admin doen't choose that reservation is paid.")
      #flash[:error] = "Admin doen't choose that reservation is paid."
      @reservation.step = "pre_payment"
      render :prepayment
    end
  end

  private

  def client_params
    params.require(:client).permit(:phone_number, :email)
  end

  def person_params
    params.require(:client).permit(:name, :surname)
  end

  def reservation_params
    params.require(:reservation).permit(:date_from, :date_to, :step, :client_id, :room_id)
  end

  def reservation_date_params
    params.require(:reservation).permit(:date_from_standart, :date_to_standart, :date_to_luxe, :date_from_luxe)
  end

  def payment_params
    params.require(:reservation).permit(:payment)
  end

  def type_of_room
    params[:reservation][:type_of_room]
  end

  def date_to
    if reservation_date_params[:date_to_standart].blank?
      reservation_date_params[:date_to_luxe]
    else
      reservation_date_params[:date_to_standart]
    end
  end

  def date_from
    if reservation_date_params[:date_from_standart].blank?
      reservation_date_params[:date_from_luxe]
    else
      reservation_date_params[:date_from_standart]
    end
  end
end
