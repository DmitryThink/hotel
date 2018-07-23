class RoomDate < ApplicationRecord
  validates :number, presence: true
  validate :number_less_than_zero
  validate :number_more_than_rooms
  validate :number_of_reservation

  belongs_to :room
  has_many :clients
  has_and_belongs_to_many :reservations

  def number_less_than_zero
    if number < 0
      errors.add(:number, "can't be less than 0")
    end
  end

  def number_more_than_rooms
    if number > room.number
      errors.add(:number, "can't be More than number of room")
    end
  end

  def number_of_reservation
    if room.number - number != reservations.count
      errors.add(:base, "Тревога! Даты не совпадают!")
    end
  end

  def check_in
    Reservation.where(date_from: date).where('paid=? OR prepaid=?', true, true)
  end

  def check_out
    Reservation.where(date_to: date).where('paid=? OR prepaid=?', true, true)
  end

  def check_in_list
    surname_list(check_in)
  end

  def check_out_list
    surname_list(check_out)
  end

  def surname_list(check)
    list = []
    check.each do |reservation|
      list << reservation.client.surname
    end
    list.uniq!
    string = ""
    list.each_with_index do |surname, i|
      if i < list.length-1
        string += surname + ", "
      else
        string += surname
      end
    end
    string
  end
end
