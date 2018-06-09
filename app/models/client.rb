class Client < ApplicationRecord
  has_one :person, as: :personable

  delegate :name,
           :surname,
           to: :person


  has_many :reservations
end
