class Message < ApplicationRecord
  validates :phone_number, length: { minimum: 10, maximum: 20 }
  validates :name, :phone_number, presence: true
  validate :phone_number_format

  def phone_number_format
    unless phone_number.match(/\+?\d*/).to_s == phone_number
      errors.add(:phone_number, " неправильного формата")
    end
  end
end
