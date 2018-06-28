class Client < ApplicationRecord
  validates :phone_number, length: { minimum: 6, maximum: 255 }, presence: true, uniqueness: true

  attr_reader :date_from, :date_to, :type_of_room

  has_many :reservations

  def destroy
    ActiveRecord::Base.transaction do
      reservations.each do |r|
        r.destroy
      end
      super
    end
  end
end
