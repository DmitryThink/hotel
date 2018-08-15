require 'rails_helper'

RSpec.describe Reservation, type: :model do
  context 'with different dates' do
    let!(:standart) { create(:room, :standart) }
    # let!(:luxe) { create(:room, :luxe) }
    let!(:june) { create(:month, :june, room: standart) }
    let!(:july) { create(:month, :july, room: standart) }
    let!(:may) { create(:month, :may, room: standart) }
    let!(:client) { create(:client)}
    context 'check invalid dates' do
      it 'two correct dates' do
        r = Reservation.create!(date_from: "16.06.2018", date_to: "20.06.2018", room: standart, client: client)
        r.prepaid = true
        r.save!
        expect(r).to be_valid
      end

      it '3 reservation valid, and last not, same dates' do
        Reservation.create!(date_from: "01.06.2018", date_to: "15.06.2018", room: standart, client: client)
        Reservation.create!(date_from: "01.06.2018", date_to: "15.06.2018", room: standart, client: client)
        Reservation.create!(date_from: "01.06.2018", date_to: "15.06.2018", room: standart, client: client)
        expect { Reservation.create!(date_from: "01.06.2018", date_to: "15.06.2018", room: standart, client: client) }.to raise_error(ActiveRecord::RecordInvalid)
      end

      it '3 reservation valid, and last not, different dates' do
        Reservation.create!(date_from: "01.06.2018", date_to: "15.06.2018", room: standart, client: client)
        Reservation.create!(date_from: "01.06.2018", date_to: "15.07.2018", room: standart, client: client)
        Reservation.create!(date_from: "04.06.2018", date_to: "31.06.2018", room: standart, client: client)
        expect { Reservation.create!(date_from: "01.06.2018", date_to: "15.06.2018", room: standart, client: client) }.to raise_error(ActiveRecord::RecordInvalid)
      end

      it 'reservation with crossed dates' do
        Reservation.create!(date_from: "01.06.2018", date_to: "05.06.2018", room: standart, client: client)
        Reservation.create!(date_from: "05.06.2018", date_to: "10.06.2018", room: standart, client: client)
        Reservation.create!(date_from: "10.06.2018", date_to: "15.06.2018", room: standart, client: client)
        Reservation.create!(date_from: "01.06.2018", date_to: "05.06.2018", room: standart, client: client)
        Reservation.create!(date_from: "05.06.2018", date_to: "10.06.2018", room: standart, client: client)
        Reservation.create!(date_from: "10.06.2018", date_to: "15.06.2018", room: standart, client: client)
        Reservation.create!(date_from: "01.06.2018", date_to: "05.06.2018", room: standart, client: client)
        Reservation.create!(date_from: "05.06.2018", date_to: "10.06.2018", room: standart, client: client)
        Reservation.create!(date_from: "10.06.2018", date_to: "15.06.2018", room: standart, client: client)
        expect { Reservation.create!(date_from: "01.06.2018", date_to: "05.06.2018", room: standart, client: client) }.to raise_error(ActiveRecord::RecordInvalid)
      end

      it '3 prepaid reservation valid' do
        r1 = Reservation.create!(date_from: "01.06.2018", date_to: "15.06.2018", room: standart, client: client, created_at: Time.current - 10.days, updated_at: Time.current - 10.days)
        r2 = Reservation.create!(date_from: "01.06.2018", date_to: "15.06.2018", room: standart, client: client, created_at: Time.current - 10.days, updated_at: Time.current - 10.days)
        r3 = Reservation.create!(date_from: "01.06.2018", date_to: "15.06.2018", room: standart, client: client, created_at: Time.current - 10.days, updated_at: Time.current - 10.days)
        r1.update!(prepaid: true)
        r2.update!(prepaid: true)
        r3.update!(prepaid: true)
        expect { Reservation.create!(date_from: "01.06.2018", date_to: "15.06.2018", room: standart, client: client) }.to raise_error(ActiveRecord::RecordInvalid)
      end

      it 'reservation with 3 month of book' do
        r = Reservation.create!(date_from: "01.05.2018", date_to: "31.07.2018", room: standart, client: client)
        r.calculate_total_price
        expect(r.total_price).to eq(may.price * may.max_days + june.price * june.max_days + july.price * (july.max_days-1))
      end

      it 'reservation with 3 different month' do
        Reservation.create!(date_from: "01.05.2018", date_to: "31.05.2018", room: standart, client: client)
        Reservation.create!(date_from: "01.06.2018", date_to: "30.06.2018", room: standart, client: client)
        Reservation.create!(date_from: "01.07.2018", date_to: "31.07.2018", room: standart, client: client)
        Reservation.create!(date_from: "01.05.2018", date_to: "31.05.2018", room: standart, client: client)
        Reservation.create!(date_from: "01.06.2018", date_to: "30.06.2018", room: standart, client: client)
        Reservation.create!(date_from: "01.07.2018", date_to: "31.07.2018", room: standart, client: client)
        r1 = Reservation.create!(date_from: "01.05.2018", date_to: "31.05.2018", room: standart, client: client)
        r2 = Reservation.create!(date_from: "01.06.2018", date_to: "30.06.2018", room: standart, client: client)
        r3 = Reservation.create!(date_from: "01.07.2018", date_to: "31.07.2018", room: standart, client: client)
        r1.calculate_total_price
        r2.calculate_total_price
        r3.calculate_total_price
        expect(r1.total_price).to eq(may.price*(may.max_days-1))
        expect(r2.total_price).to eq(june.price*(june.max_days-1))
        expect(r3.total_price).to eq(july.price*(july.max_days-1))
        expect { Reservation.create!(date_from: "01.05.2018", date_to: "31.05.2018", room: standart, client: client) }.to raise_error(ActiveRecord::RecordInvalid)
        expect { Reservation.create!(date_from: "01.06.2018", date_to: "30.06.2018", room: standart, client: client) }.to raise_error(ActiveRecord::RecordInvalid)
        expect { Reservation.create!(date_from: "01.07.2018", date_to: "31.07.2018", room: standart, client: client) }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end
end
