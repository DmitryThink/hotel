class Driver < ApplicationRecord
  has_one :worker, as: :workable

  delegate :name,
           :surname,
           to: :worker, allow_nil: true

  has_many :trips
end
