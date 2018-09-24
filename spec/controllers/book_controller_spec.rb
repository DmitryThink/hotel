require 'rails_helper'
RSpec.describe BookController do
  describe "Post", :type => :request  do
    it 'creates reservation with invalid params' do
      post "/reservations", params: { reservation: { date_from: 'b', date_to: 'h', message: 's'},
                                      client: { name: 'p', surname: 'e', phone_number: 'ph', email: 'a' },
                                      type_of_room: 's', format: :json  }
      expect(Reservation.count).to eq(0)
    end
    it 'creates reservation with valid params' do
      post "/reservations", params: {"reservation"=>{"date_from"=>"24/09/2018", "date_to"=>"27/09/2018", "message"=>""},
                                     "client"=>{"name"=>"tertet", "surname"=>"ertertert", "phone_number"=>"43345345345345", "email"=>"ertert@sr.n"},
                                     "type_of_room"=>"Standart"}
      expect(Reservation.count).to eq(1)
      expect(Client.count).to eq(1)
    end
  end
end