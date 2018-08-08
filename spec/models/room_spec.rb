require 'rails_helper'

RSpec.describe Room, type: :model do
  context 'with two rooms' do
    before(:all) do
      @date_from = "01.06.2018"
      @date_to = "15.06.2018"
      @type_of_room = "standart"
      @room1 = Room.create!(id:1, number_of_people: 3, type_of_room: @type_of_room )
      @room2 = Room.create!(id:2, number_of_people: 3, type_of_room: @type_of_room )
      @client = Client.new(name: "Bill", surname: "Clinton")
      Reservation.create!(date_from: @date_from, date_to: @date_to, room: @room1, client: @client)
    end
    after(:all) do
      Reservation.destroy_all
      Room.destroy_all
      Client.destroy_all
    end

    # it 'free_rooms? must ruturn true' do
    #   expect(Room.free_rooms?(@type_of_room, @date_from, @date_to)).to eq(true)
    # end
    #
    # it 'free_rooms must return room2' do
    #   expect(Room.free_rooms(@type_of_room, @date_from, @date_to).first).to eq(@room2)
    # end
    #
    # it 'free_rooms? must ruturn false' do
    #   Reservation.create!(date_from: @date_from, date_to: @date_to, room: @room2, client: @client)
    #   expect(Room.free_rooms?(@type_of_room, @date_from, @date_to)).to eq(false)
    # end
  end
end
