class Worker < ApplicationRecord
  include IWorker
  has_one :person, as: :personable

  belongs_to :workable, polymorphic: true

  delegate :name,
           :surname,
           to: :person

end