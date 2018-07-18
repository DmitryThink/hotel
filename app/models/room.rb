class Room < ApplicationRecord
  validates :number, uniqueness: true

  enum type_of_room: [ :standart, :luxe ]

  has_many :reservations
  has_many :room_dates

  def to_s
    type_of_room
  end

  def type_of_room_ru
    if type_of_room == "standart"
      "Стандарт"
    elsif type_of_room == "luxe"
      "Люкс"
    end
  end
end
