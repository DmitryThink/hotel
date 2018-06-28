class GenarateDates
  def procces!
    year =  Date.today.year
    sd = Date.parse("#{year}-06-01")
    ed = Date.parse("#{year}-09-30")

    sd.upto(ed).each do |date|
      month = date.strftime("%m")
      if month == '06'
        price = 800
      elsif month == '07'
        price = 1000
      elsif month == '08'
        price = 900
      elsif month == '09'
        price = 700
      end

      RoomDate.create!(date: date, number: 8, room: Room.find(1), price: price)
      RoomDate.create!(date: date, number: 6, room: Room.find(2), price: price + 200)
    end
  end
end