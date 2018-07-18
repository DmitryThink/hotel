class Reservation < ApplicationRecord
  validates :date_from, :date_to, presence: true
  validate :busy_dates

  delegate :name, :surname, :phone_number, :email, to: :client, allow_nil: true
  delegate :type_of_room, :type_of_room_ru, to: :room, allow_nil: true

  belongs_to :client
  belongs_to :room
  has_and_belongs_to_many :room_dates

  def standart_dates
    dates(1)
  end

  def luxe_dates
    dates(2)
  end

  def dates(room_id)
    dates = []
    Room.find(room_id).room_dates.where(number:0).each do |room_date|
      dates << room_date.date.strftime("%d.%m.%Y")
    end
    dates
  end

  def busy_dates
    if room_dates.any? { |room_date| room_date.number == 0 }
      errors.add(:room, "We have't this room on this dates!")
    end
  end

  def destroy
    ActiveRecord::Base.transaction do
      room_dates.each do |date|
        date.number += 1
        date.save!
      end
      super
    end
  end

  def prepayment
    total_price/2
  end
end
