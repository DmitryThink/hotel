require 'rails_helper'

RSpec.describe Reservation, type: :model do
  context 'with different dates' do
    before(:all) do
      @room = Room.create!(id:1, number: 1, number_of_people: 3, type_of_room: "standart")
      @room2 = Room.create!(id:2, number: 1, number_of_people: 4, type_of_room: "luxe")
      year =  Date.today.year
      sd = Date.parse("#{year}-05-01")
      ed = Date.parse("#{year}-06-30")

      sd.upto(ed).each do |date|
        month = date.strftime("%m")
        if month == '05'
          price = 600
        elsif month == '06'
          price = 800
        end

        RoomDate.create!(date: date, number: 1, room: @room, price: price)
        RoomDate.create!(date: date, number: 1, room: @room2, price: price + 200)
      end
      @client = Client.create!(name: "Bill", surname: "Clinton", phone_number: "123123123123", email: "asdas@sfd.com")
      r = Reservation.create!(date_from: "01.06.2018", date_to: "15.06.2018", room: @room, client: @client)
      r.update!(prepaid: true)
    end

    after(:all) do
      RoomDate.destroy_all
      Reservation.destroy_all
      Room.destroy_all
      Client.destroy_all
    end

    context 'check invalid dates' do
      it 'two correct dates' do
        r = Reservation.create!(date_from: "16.06.2018", date_to: "20.06.2018", room: @room, client: @client)
        r.prepaid = true
        r.save!
        expect(r).to be_valid
      end
      it '(1) incorrect date (the same)' do
        r = Reservation.create!(date_from: "01.06.2018", date_to: "15.06.2018", room: @room, client: @client)
        r.prepaid = true
        expect { r.save! }.to raise_error(ActiveRecord::RecordInvalid)
      end
      it '(2) incorrect date (date_from< && date_to<)' do
        r = Reservation.create!(date_from: "01.05.2018", date_to: "14.06.2018", room: @room, client: @client)
        r.prepaid = true
        expect { r.save! }.to raise_error(ActiveRecord::RecordInvalid)
      end
      it '(3) incorrect date (date_from> && date_to<)' do
        r = Reservation.create!(date_from: "03.05.2018", date_to: "14.06.2018", room: @room, client: @client)
        r.prepaid = true
        expect { r.save! }.to raise_error(ActiveRecord::RecordInvalid)
      end
      it '(4) incorrect date (date_from< && date_to>)' do
        r = Reservation.create!(date_from: "01.05.2018", date_to: "30.06.2018", room: @room, client: @client)
        r.prepaid = true
        expect { r.save! }.to raise_error(ActiveRecord::RecordInvalid)
      end
      it '(5) incorrect date (date_from> && date_to>)' do
        r = Reservation.create!(date_from: "07.06.2018", date_to: "30.06.2018", room: @room, client: @client)
        r.prepaid = true
        expect { r.save! }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    context 'check room_dates' do
      it 'checks number of dates' do
        r = Reservation.create!(date_from: "01.06.2018", date_to: "15.06.2018", room: @room, client: @client)
        expect { r.update!(prepaid: !r.prepaid) }.to raise_error(ActiveRecord::RecordInvalid)
        expect(Reservation.find(r.id).room_dates.count).to eq 0
        expect(Reservation.find(r.id).prepaid?).to eq false
      end
    end
  end
end
