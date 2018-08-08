module Scr
  class GenerateMonth
    def process!
      standart = Room.find_or_create_by(id: 1, number: 8, number_of_people: 3, type_of_room: "standart")
      luxe = Room.find_or_create_by(id: 2, number: 6, number_of_people: 4, type_of_room: "luxe")
      Month.destroy_all
      calculate_month(standart, 600, 800, 900, 900, 600)
      calculate_month(luxe, 700, 1000, 1100, 1100, 700)
    end

    private

    def calculate_month(room, may, jun, jul, aug, sep)
      month_number = 5
      ({'May':[may,31], 'June': [jun,30], 'July': [jul,31], 'August': [aug,31], 'September': [sep,30]}).each do |month_name, pm_arr|
        month_params = {name: month_name, price: pm_arr.first, number: month_number, room: room, max_days: pm_arr.last}

        (1..pm_arr.last).each do |day_number|
          month_params.merge!("day_#{day_number}": room.number)
        end

        Month.create!(month_params)
        month_number += 1
      end
    end
  end
end