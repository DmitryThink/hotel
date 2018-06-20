class Trip < ApplicationRecord
  belongs_to :place
  belongs_to :driver
  has_and_belongs_to_many :people
end
