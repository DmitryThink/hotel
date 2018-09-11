class Room < ApplicationRecord
  enum type_of_room: [ :standart, :luxe ]

  has_many :reservations
  has_many :room_dates
  has_many :months

  def to_s
    type_of_room
  end

  def type_of_room_ru
    return if type_of_room.nil?
    if type_of_room == "standart"
      "Стандарт"
    elsif type_of_room == "luxe"
      "Люкс"
    end
  end
end
