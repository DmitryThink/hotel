class Cook < ApplicationRecord
  has_one :worker, as: :workable

  delegate :name,
           :surname,
           to: :worker, allow_nil: true

  has_and_belongs_to_many :meals
end
