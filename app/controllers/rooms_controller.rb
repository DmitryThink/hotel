class RoomsController < ApplicationController
  def index
    @room_standart = Room.find_by(type_of_room: "standart")
    @room_luxe = Room.find_by(type_of_room: "luxe")
  end

  def standart
    @reservation = Reservation.new
    @client = Client.new
    @room = Room.find_by(type_of_room: "standart")
  end

  def luxe
    @reservation = Reservation.new
    @client = Client.new
    @room = Room.find_by(type_of_room: "luxe")
  end
end
