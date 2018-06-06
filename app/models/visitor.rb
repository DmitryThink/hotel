class Visitor < Person
  has_and_belongs_to_many :reservations
  has_and_belongs_to_many :trips
end
