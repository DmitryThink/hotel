class Meal < ApplicationRecord
  has_and_belongs_to_many :cooks
  has_and_belongs_to_many :orders

  def to_s
    name + " " + price.to_s
  end
end
