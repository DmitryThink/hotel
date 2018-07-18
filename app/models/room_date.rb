class RoomDate < ApplicationRecord
  validates :number, presence: true
  validate :number_less_than_zero
  validate :number_more_than_rooms

  belongs_to :room
  has_many :clients
  has_and_belongs_to_many :reservations

  def number_less_than_zero
    if number < 0
      errors.add(:number, "Can't be less than 0")
    end
  end

  def number_e
    number
  end

  def number_more_than_rooms
    if number > room.number
      errors.add(:number, "Can't be More than number of room")
    end
  end

  def check_in
    Reservation.where(date_from: date)
  end

  def check_out
    Reservation.where(date_to: date)
  end

  def check_in_list
    list = ""
    check_in.each do |reservation|
      list += "#{reservation.client.surname}, "
    end
    list
  end

  def check_out_list
    list = ""
    check_in.each do |reservation|
      list += "#{reservation.client.surname}, "
    end
    list
  end
end
