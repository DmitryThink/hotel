class Person < ApplicationRecord
  include IPerson
  belongs_to :personable, polymorphic: true

  validates :name, :surname, length: { minimum: 2, maximum: 255 }, presence: true
end