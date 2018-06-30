class BookController < ApplicationController
  def index
    @client = Client.new
    @reservation = Reservation.new(client: @client)
  end

  def create
    ActiveRecord::Base.transaction do
      client = Client.create!(client_params)
      room = Room.find_by(type_of_room: type_of_room)

      @reservation = Reservation.new(date_from: date_from, date_to: date_to, room: room, client: client)
      sd = Date.parse(date_from)
      ed = Date.parse(date_to)
      sd.upto(ed).each do |date|
        room_date = RoomDate.find_by(date: date, room: room)
        room_date.number = room_date.number - 1
        room_date.reservations << @reservation
        room_date.save!
      end

      if @reservation.valid?
        @reservation.save!
        render :succeed
      else
        render :index
      end
    end
  end

  # def update
  #   create
  # end
  #
  # def show
  #   prepayment
  # end
  #
  # def choose_date
  #   if Room.free_rooms?(type_of_room, date_from, date_to)
  #     @reservation = Reservation.new(date_from: date_from,
  #                                        date_to: date_to,
  #                                        client: @reservation.client,
  #                                        room: Room.free_rooms(type_of_room, date_from, date_to).first)
  #     if @reservation.valid?
  #       @reservation.total_price = @reservation.calculate_total_price
  #       @reservation.step = "choose_payment"
  #       render :choose_payment
  #     else
  #       render :choose_date
  #     end
  #   else
  #     @reservation = Reservation.new(room: Room.new, client: @reservation.client, step: "choose_date")
  #     @reservation.errors.add(:base, "We haven't #{type_of_room} rooms with this dates!")
  #     render :choose_date
  #   end
  # end
  #
  # def choose_payment
  #   @reservation.payment = payment_params[:payment]
  #   if @reservation.valid?
  #     if payment_params[:payment] == "card"
  #       @reservation.step = "payment"
  #       render :payment
  #     else
  #       @reservation.save!
  #       @reservation.step = "pre_payment"
  #       render :prepayment
  #     end
  #   else
  #     render :choose_payment
  #   end
  # end
  #
  # def payment
  #   @reservation.save!
  #   @reservations = @reservation.client.reservations
  #   render :succeed
  # end
  #
  # def prepayment
  #   @reservation = Reservation.find(params[:id] || params[:reservation][:id])
  #   if @reservation.paid
  #     @reservation.save!
  #     render :succeed
  #   else
  #     @reservation.errors.add(:base, "Admin doen't choose that reservation is paid.")
  #     #flash[:error] = "Admin doen't choose that reservation is paid."
  #     @reservation.step = "pre_payment"
  #     render :prepayment
  #   end
  # end

  private

  def client_params
    params.require(:reservation).permit(:name, :surname, :phone_number, :email)
  end

  def reservation_params
    params.require(:reservation).permit(:date_from, :date_to, :client_id, :room_id)
  end

  def reservation_date_params
    params.require(:reservation).permit(:date_from_standart, :date_to_standart, :date_to_luxe, :date_from_luxe)
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
