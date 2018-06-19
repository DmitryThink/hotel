class Order < ApplicationRecord
  has_and_belongs_to_many :meals
  belongs_to :reservation, optional: true

  attr_reader :price

  def price
    price = 0
    meals.each do |meal|
      price += meal.price
    end
    price
  end
end
