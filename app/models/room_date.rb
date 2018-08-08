class RoomDate < ApplicationRecord
  belongs_to :room
  has_many :reservations_room_dates
  has_many :reservations, through: :reservations_room_dates
end
