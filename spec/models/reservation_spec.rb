require 'rails_helper'

RSpec.describe Reservation, type: :model do
  context 'with different dates' do
    before(:all) do
      @room = Room.new(id:1, number: 1, number_of_people: 3, price: 900)
      @client = Client.new(name: "Bill", surname: "Clinton")
      Reservation.create!(date_from: "01.06.2018", date_to: "15.06.2018", room: @room, client: @client)
    end
    after(:all) do
      Reservation.destroy_all
      Room.destroy_all
      Client.destroy_all
    end

    it 'two correct dates' do
      expect(Reservation.new(date_from: "16.06.2018", date_to: "18.06.2018", room: @room, client: @client)).to be_valid
    end
    it '(1) incorrect date (the same)' do
      expect(Reservation.new(date_from: "01.06.2018", date_to: "15.06.2018", room: @room, client: @client)).to be_invalid
    end
    it '(2) incorrect date (date_from< && date_to<)' do
      expect(Reservation.new(date_from: "01.05.2018", date_to: "14.06.2018", room: @room, client: @client)).to be_invalid
    end
    it '(3) incorrect date (date_from> && date_to<)' do
      expect(Reservation.new(date_from: "03.05.2018", date_to: "14.06.2018", room: @room, client: @client)).to be_invalid
    end
    it '(4) incorrect date (date_from< && date_to>)' do
      expect(Reservation.new(date_from: "01.05.2018", date_to: "30.06.2018", room: @room, client: @client)).to be_invalid
    end
    it '(5) incorrect date (date_from> && date_to>)' do
      expect(Reservation.new(date_from: "07.06.2018", date_to: "30.06.2018", room: @room, client: @client)).to be_invalid
    end
    it '(5) incorrect date (the same), but room another' do
      room = Room.new(id: 2, number: 2, number_of_people: 3, price: 900)
      expect(Reservation.new(date_from: "07.06.2018", date_to: "30.06.2018", room: room, client: @client)).to be_valid
    end
  end
end
