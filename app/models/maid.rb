class Maid < ApplicationRecord
  has_one :worker, as: :workable

  delegate :name,
           :surname,
           :salary,
           to: :worker, allow_nil: true

  has_and_belongs_to_many :rooms
end
