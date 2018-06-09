class Person < ApplicationRecord
  include IPerson
  belongs_to :personable, polymorphic: true
end