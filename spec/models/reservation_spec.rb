require 'rails_helper'

RSpec.describe Reservation, type: :model do
  context 'with different dates' do
    let!(:standart) { create(:room, :standart) }
    let!(:june) { create(:month, :june, room: standart) }
    let!(:july) { create(:month, :july, room: standart) }
    let!(:may) { create(:month, :may, room: standart) }
    let!(:client) { create(:client)}
    context 'checks' do
      it 'two correct dates' do
        r = described_class.create!(date_from: "16.06.2018", date_to: "20.06.2018", room: standart, client: client)
        r.prepaid = true
        r.save!
        expect(r).to be_valid
      end

      it '3 reservation valid, and last not, same dates' do
        described_class.create!(date_from: "01.06.2018", date_to: "15.06.2018", room: standart, client: client)
        described_class.create!(date_from: "01.06.2018", date_to: "15.06.2018", room: standart, client: client)
        described_class.create!(date_from: "01.06.2018", date_to: "15.06.2018", room: standart, client: client)
        expect { described_class.create!(date_from: "01.06.2018", date_to: "15.06.2018", room: standart, client: client) }.to raise_error(ActiveRecord::RecordInvalid)
      end

      it '3 reservation valid, and last not, different dates' do
        described_class.create!(date_from: "01.06.2018", date_to: "15.06.2018", room: standart, client: client)
        described_class.create!(date_from: "01.06.2018", date_to: "15.07.2018", room: standart, client: client)
        described_class.create!(date_from: "04.06.2018", date_to: "31.06.2018", room: standart, client: client)
        expect { described_class.create!(date_from: "01.06.2018", date_to: "15.06.2018", room: standart, client: client) }.to raise_error(ActiveRecord::RecordInvalid)
      end

      it '3 reservation valid, and last not, different dates (2)' do
        described_class.create!(date_from: "29.05.2018", date_to: "17.06.2018", room: standart, client: client)
        described_class.create!(date_from: "01.06.2018", date_to: "14.07.2018", room: standart, client: client)
        described_class.create!(date_from: "13.06.2018", date_to: "16.06.2018", room: standart, client: client)
        expect { described_class.create!(date_from: "01.06.2018", date_to: "15.06.2018", room: standart, client: client) }.to raise_error(ActiveRecord::RecordInvalid)
      end

      it 'reservation with crossed dates' do
        described_class.create!(date_from: "01.06.2018", date_to: "05.06.2018", room: standart, client: client)
        described_class.create!(date_from: "05.06.2018", date_to: "10.06.2018", room: standart, client: client)
        described_class.create!(date_from: "10.06.2018", date_to: "15.06.2018", room: standart, client: client)
        described_class.create!(date_from: "01.06.2018", date_to: "05.06.2018", room: standart, client: client)
        described_class.create!(date_from: "05.06.2018", date_to: "10.06.2018", room: standart, client: client)
        described_class.create!(date_from: "10.06.2018", date_to: "15.06.2018", room: standart, client: client)
        described_class.create!(date_from: "01.06.2018", date_to: "05.06.2018", room: standart, client: client)
        described_class.create!(date_from: "05.06.2018", date_to: "10.06.2018", room: standart, client: client)
        described_class.create!(date_from: "10.06.2018", date_to: "15.06.2018", room: standart, client: client)
        expect { described_class.create!(date_from: "01.06.2018", date_to: "05.06.2018", room: standart, client: client) }.to raise_error(ActiveRecord::RecordInvalid)
      end

      it '3 prepaid reservation valid' do
        r1 = described_class.create!(date_from: "01.06.2018", date_to: "15.06.2018", room: standart, client: client, created_at: Time.current - 10.days, updated_at: Time.current - 10.days)
        r2 = described_class.create!(date_from: "01.06.2018", date_to: "15.06.2018", room: standart, client: client, created_at: Time.current - 10.days, updated_at: Time.current - 10.days)
        r3 = described_class.create!(date_from: "01.06.2018", date_to: "15.06.2018", room: standart, client: client, created_at: Time.current - 10.days, updated_at: Time.current - 10.days)
        r1.update!(prepaid: true)
        r2.update!(prepaid: true)
        r3.update!(prepaid: true)
        expect(RoomDate.count).to eq(2)
        expect(ReservationsRoomDate.count).to eq(6)
        expect { described_class.create!(date_from: "01.06.2018", date_to: "15.06.2018", room: standart, client: client) }.to raise_error(ActiveRecord::RecordInvalid)
      end

      it 'reservation with 3 month of book' do
        r = described_class.create!(date_from: "01.05.2018", date_to: "31.07.2018", room: standart, client: client)
        r.calculate_total_price
        expect(r.total_price).to eq(may.price * may.max_days + june.price * june.max_days + july.price * (july.max_days-1))
      end

      it 'reservation with 3 different month' do
        described_class.create!(date_from: "01.05.2018", date_to: "31.05.2018", room: standart, client: client)
        described_class.create!(date_from: "01.06.2018", date_to: "30.06.2018", room: standart, client: client)
        described_class.create!(date_from: "01.07.2018", date_to: "31.07.2018", room: standart, client: client)
        described_class.create!(date_from: "01.05.2018", date_to: "31.05.2018", room: standart, client: client)
        described_class.create!(date_from: "01.06.2018", date_to: "30.06.2018", room: standart, client: client)
        described_class.create!(date_from: "01.07.2018", date_to: "31.07.2018", room: standart, client: client)
        r1 = described_class.create!(date_from: "01.05.2018", date_to: "31.05.2018", room: standart, client: client)
        r2 = described_class.create!(date_from: "01.06.2018", date_to: "30.06.2018", room: standart, client: client)
        r3 = described_class.create!(date_from: "01.07.2018", date_to: "31.07.2018", room: standart, client: client)
        r1.calculate_total_price
        r2.calculate_total_price
        r3.calculate_total_price
        expect(r1.total_price).to eq(may.price*(may.max_days-1))
        expect(r2.total_price).to eq(june.price*(june.max_days-1))
        expect(r3.total_price).to eq(july.price*(july.max_days-1))
        expect { described_class.create!(date_from: "01.05.2018", date_to: "31.05.2018", room: standart, client: client) }.to raise_error(ActiveRecord::RecordInvalid)
        expect { described_class.create!(date_from: "01.06.2018", date_to: "30.06.2018", room: standart, client: client) }.to raise_error(ActiveRecord::RecordInvalid)
        expect { described_class.create!(date_from: "01.07.2018", date_to: "31.07.2018", room: standart, client: client) }.to raise_error(ActiveRecord::RecordInvalid)
      end

      it 'reservation with 3 month of book' do
        r = described_class.create!(date_from: "01.05.2018", date_to: "31.07.2018", room: standart, client: client)
        r.calculate_total_price
        r.update!(prepaid: true)
        expect(RoomDate.count).to eq(2)
        expect(ReservationsRoomDate.count).to eq(2)
        expect(r.paid).to eq(false)
        r.update!(prepaid: false)
        expect(RoomDate.count).to eq(0)
        expect(ReservationsRoomDate.count).to eq(0)
        expect(r.paid).to eq(false)
        expect { r.update!(paid: true) }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    context 'invalid reservations' do
      it 'checks if reservation dates have more than 3 days' do
        expect { described_class.create!(date_from: "01.05.2018", date_to: "01.05.2018", room: standart, client: client) }.to raise_error(ActiveRecord::RecordInvalid)
      end

      it 'checks if reservation dates have more than 3 days (2)' do
        expect { described_class.create!(date_from: "01.05.2018", date_to: "03.05.2018", room: standart, client: client) }.to raise_error(ActiveRecord::RecordInvalid)
      end

      it 'checks if reservation has date_from less than date_to' do
        expect { described_class.create!(date_from: "01.06.2018", date_to: "30.05.2018", room: standart, client: client) }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end
end