class Client < ApplicationRecord
  has_one :person, as: :personable

  delegate :name,
           :surname,
           to: :person

  validates :phone_number, length: { minimum: 6, maximum: 255 }, presence: true, uniqueness: true

  has_many :reservations
end
