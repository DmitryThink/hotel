class Reservation < ApplicationRecord
  validates :date_from, :date_to, presence: true
  validate :dates_validation
  validate :number_with_dates_validation

  belongs_to :room
  has_many :orders
  belongs_to :client

  delegate :number,
           :number_of_peole,
           :type_of_room,
           to: :room

  def luxe_dates
    Room.dates("luxe")
  end

  def standart_dates
    Room.dates("standart")
  end

  def number_with_dates_validation
    if Reservation.invalid_dates?(date_from, date_to, room, id)
      errors[:base] << "Reservation with this dates alraady exists!"
    end
  end

  def dates_validation
    if date_from > date_to
      errors.add(:date_to, "must be higher than date_from!")
    end
  end

  def self.invalid_dates?(date_from, date_to, room, id = nil)
    reservations = Reservation.where(room: room)
    reservations.any? {|reservation| ((date_from >= reservation.date_from &&
        date_from <= reservation.date_to) ||
        (date_to >= reservation.date_from &&
            date_to <= reservation.date_to) ||
        (date_from < reservation.date_from &&
            date_to > reservation.date_to)) && reservation.id != id }
  end

  def calculate_total_price
    total_price = room.price
    orders.each do |order|
      total_price += order.price
    end
    update!(total_price: total_price)
    total_price
  end
end
