class Visitor < ApplicationRecord
  has_one :person, as: :personable

  delegate :name,
           :surname,
           to: :person

  has_and_belongs_to_many :reservations
  has_and_belongs_to_many :trips
end
