class Reservation < ApplicationRecord
  validates :date_from, :date_to, presence: true
  validate :busy_dates

  belongs_to :client
  belongs_to :room
  has_and_belongs_to_many :room_dates

  def busy_dates
    if room_dates.any { |room_date| room_date.number == 0 }
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
end
