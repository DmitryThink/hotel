class ReservationsRoomDate < ApplicationRecord
  belongs_to :reservation
  belongs_to :room_date
  enum check: [:check_in, :check_out]
end