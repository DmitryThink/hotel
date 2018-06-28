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

  def number_more_than_rooms
    if number > room.number
      errors.add(:number, "Can't be More than number of room")
    end
  end
end
