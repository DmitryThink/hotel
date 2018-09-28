class Room < ApplicationRecord
  has_many :reservations
  has_many :room_dates
  has_many :months
  has_many :items

  validates :name, :name_ru, :number, presence: true

  after_create :setup_room

  def to_s
    name
  end

  def setup_room
    (Month.start_month..Month.end_month).each do |month_number|
      Month.create!(number: month_number, price: 1000, room: self)
    end
  end

  def self.all
    super.order(:id)
  end
end
