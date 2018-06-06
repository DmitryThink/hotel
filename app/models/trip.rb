class Trip < ApplicationRecord
  belongs_to :place
  belongs_to :driver
  has_many :visitors
end
