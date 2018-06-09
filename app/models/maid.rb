class Maid < ApplicationRecord
  has_one :worker, as: :workable

  delegate :name,
           :surname,
           to: :worker

  has_and_belongs_to_many :rooms
end
