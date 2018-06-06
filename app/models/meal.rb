class Meal < ApplicationRecord
  has_and_belongs_to_many :cooks
  has_and_belongs_to_many :orders
end
