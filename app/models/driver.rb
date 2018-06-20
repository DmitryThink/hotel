class Driver < ApplicationRecord
  has_one :worker, as: :workable

  delegate :name,
           :surname,
           :salary,
           to: :worker, allow_nil: true

  has_many :trips
end
