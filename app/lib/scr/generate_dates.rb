module Scr
  class GenerateDates
    def process!(may = nil, jun = nil, jul = nil, aug = nil, sep = nil)
      Room.find_or_create_by(id: 1, number: 8, number_of_people: 3, name: "standart")
      Room.find_or_create_by(id: 2, number: 6, number_of_people: 4, name: "room")
      RoomDate.destroy_all

      year =  Date.today.year
      sd = Date.parse("#{year}-05-01")
      ed = Date.parse("#{year}-09-30")

      sd.upto(ed).each do |date|
        case date.strftime("%m")
        when '05'
          price = may || 600
        when '06'
          price = jun || 800
        when'07'
          price = jul || 1000
        when '08'
          price = aug || 900
        when '09'
          price = sep || 700
        end

        RoomDate.create!(date: date, number: 8, room: Room.find(1), price: price)
        RoomDate.create!(date: date, number: 6, room: Room.find(2), price: price + 200)
      end
    end
  end
end
