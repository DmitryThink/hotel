class Client < ApplicationRecord
  validates :phone_number, length: { minimum: 10, maximum: 20 }
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :name, :surname, :email, :phone_number, presence: true
  validate :phone_number_format

  has_many :reservations
  attr_reader :date_from, :date_to, :room_name

  def destroy
    ActiveRecord::Base.transaction do
      reservations.each do |reservation|
        reservation.destroy
      end
      super
    end
  end

  def email=(email)
    super(email.downcase)
  end

  def phone_number_format
    unless phone_number.match(/\+?\d*/).to_s == phone_number
      errors.add(:phone_number, " неправильного формата")
    end
  end
end
