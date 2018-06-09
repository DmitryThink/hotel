class IndexController < ApplicationController
  def index
    @client = Client.new(person: Person.new)
    @reservation = Reservation.new(room: Room.new(id:1), client: @client)
  end

  def create
    @client = Client.new(client_params)
    @client.person = Person.new(person_params)

    date_from = reservation_params[:date_from]
    date_to = reservation_params[:date_to]
    if Room.free_rooms?(type_of_room, date_from, date_to)
      @reservation = Reservation.create!(date_from: date_from,
                                         date_to: date_to,
                                         client: @client,
                                         room: Room.free_rooms(type_of_room, date_from, date_to).first)
      redirect_to :succeed
    else
      @reservation = Reservation.new(reservation_params)
      @reservation.client = @client
      @reservation.room = Room.new(id:1)
      flash[:error] = "We haven't #{type_of_room} rooms with this dates!"
      render :index
    end
  end

  def succeed
    @reservation = Reservation.last
  end

  private

  def client_params
    params.require(:reservation).require(:client).permit(:phone_number, :email)
  end

  def person_params
    params.require(:reservation).require(:client).permit(:name, :surname)
  end

  def reservation_params
    params.require(:reservation).permit(:date_from, :date_to)
  end

  def type_of_room
    params[:reservation][:type_of_room]
  end
end
