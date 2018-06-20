class Person < ApplicationRecord
  include IPerson
  belongs_to :personable, polymorphic: true
  has_and_belongs_to_many :trips

  validates :name, :surname, length: { minimum: 2, maximum: 255 }, presence: true
end