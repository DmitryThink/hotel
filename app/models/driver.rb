class Driver < ApplicationRecord
  has_one :worker, as: :workable

  delegate :name,
           :surname,
           to: :worker

  has_many :trips
end
