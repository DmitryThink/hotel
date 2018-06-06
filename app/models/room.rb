class Room < ApplicationRecord
  validates :number, uniqueness: true
  validate :rooms_limit

  has_many :reservations

  enum status: [ :free, :booked, :busy ]

  enum type_of_room: [ :standart, :luxe ]

  def self.dates(type_of_room)
    dates = []
    (1..29).each do |day|
      if day < 10
        date = "0#{day}.06.2018"
        date2 = "0#{day+1}.06.2018"
      else
        date = "#{day}.06.2018"
        date2 = "#{day+1}.06.2018"
      end
      unless Room.free_rooms?(type_of_room, date, date2)
        dates << date
      end
    end
    dates
  end

  def self.free_rooms?(type_of_room, date_from, date_to)
    Room.where(type_of_room: type_of_room).any? { |room| !Reservation.invalid_dates?(date_from, date_to, room) }
  end

  def self.free_rooms(type_of_room, date_from, date_to)
    rooms = []
    Room.where(type_of_room: type_of_room).each do |room|
      if !Reservation.invalid_dates?(date_from, date_to, room)
        rooms << room
      end
    end
    rooms
  end

  def rooms_limit
    if Room.count > max_number_of_rooms
      errors.add(:number, "Number of rooms can't be more than: " + max_number_of_rooms.to_s)
    end
  end

  def free_on_date?(date)
    !reservations.any? { |reservation| date > reservation.date_from && date < reservation.date_to}
  end

  def max_number_of_rooms
    15
  end
end
