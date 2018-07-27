class Reservation < ApplicationRecord
  validates :date_from, :date_to, presence: true
  validate :busy_dates, :dates_validation, :dates_3_days_validation, unless: :prepaid, if: :reservation_new?
  validate :prepaid_true, if: :paid
  validate :all_room_dates

  delegate :name, :surname, :phone_number, :email, to: :client, allow_nil: true
  delegate :type_of_room, :type_of_room_ru, to: :room, allow_nil: true

  belongs_to :client
  belongs_to :room
  has_and_belongs_to_many :room_dates

  after_save :calculate_paid_prepaid
  after_save :calculate_room_date, if: :saved_change_to_prepaid?
  after_save :update_year_of_system

  after_destroy do
    ActiveRecord::Base.transaction do
      sd = Date.parse(date_from.to_s)
      ed = Date.parse(date_to.to_s) - 1.day
      sd.upto(ed).each do |date|
        room_date = RoomDate.find_by(date: date, room: room)
        room_date.number += 1
        room_date.save!
      end
    end
  end

  def reservation_new?
    created_at == updated_at
  end

  def standart_dates
    dates(1)
  end

  def luxe_dates
    dates(2)
  end

  def dates(room_id)
    dates = []
    Room.find(room_id).room_dates.where(number:0).each do |room_date|
      dates << room_date.date.strftime("%d.%m.%Y")
    end
    dates
  end

  def calculate_room_date
    Reservation.calculate_room_date(self)
  end

  def self.calculate_room_date(reservation)
    ActiveRecord::Base.transaction do
      if reservation.prepaid
        if reservation.date_from.present? && reservation.date_to.present?
          sd = Date.parse(reservation.date_from.to_s)
          ed = Date.parse(reservation.date_to.to_s) - 1.day
          sd.upto(ed).each do |date|
            room_date = RoomDate.find_by(date: date, room: reservation.room)
            if room_date.nil? || room_date.reservations.include?(reservation)
              raise ActiveRecord::Rollback, "Rolling back"
            end
            room_date.number = room_date.number - 1
            room_date.reservations << reservation
            room_date.save!
          end
        end
      else
        if reservation.date_from.present? && reservation.date_to.present?
          sd = Date.parse(reservation.date_from.to_s)
          ed = Date.parse(reservation.date_to.to_s) - 1.day
          sd.upto(ed).each do |date|
            room_date = RoomDate.find_by(date: date, room: reservation.room)
            if room_date.nil? || !room_date.reservations.include?(reservation)
              raise ActiveRecord::Rollback, "Rolling back"
            end
            room_date.number = room_date.number + 1
            room_date.reservations.delete(reservation)
            room_date.save!
          end
        end
      end
    end
  end

  def calculate_paid_prepaid
    if paid
      self.prepaid = true
    end
  end

  def prepayment
    total_price/2
  end

  def busy_dates
    sd = Date.parse(date_from.to_s)
    ed = Date.parse(date_to.to_s) - 1.day
    sd.upto(ed).each do |date|
      room_date = RoomDate.find_by(date: date, room: room)
      if room_date.nil? || room_date.number == 0
        errors.add(:base, "У нас не осталось дат на эти дни! Попробуйте другие")
      elsif Reservation.where("created_at > ?", 42.minutes.ago).where("date_from=? OR date_to=?", date, date+1.day).count == room_date.number
        errors.add(:base, "У нас не осталось дат на эти дни! Попробуйте другие")
      end
    end
  end

  def dates_validation
    if date_from > date_to
      errors.add(:date_to, "должна быть выше чем Дата въезда")
    end
  end

  def dates_3_days_validation
    if (date_to.to_date - date_from.to_date).to_i < 3
      errors.add(:base, "Нельзя взять номер меньше чем на три дня")
    end
  end

  def room_dates_presence
    if (date_to.to_date - date_from.to_date).to_i != room_dates.count
      errors.add(:base, "Тревога! Даты не совпадают")
    end
  end

  def prepaid_true
    if !prepaid && paid
      errors.add(:base, "Если оплачено то предоплата есть!")
    end
  end

  def all_room_dates
    if room_dates.any? { |room_date| room_date.invalid? }
      errors.add(:base, "room_date gg!")
    end
  end

  def update_year_of_system
    reservation = Reservation.all.first
    if reservation.present? && reservation.date_from.strftime("%Y") != Time.now.year.to_s
      Scr::GenerateDates.new.process!
    end
    true
  end

  def self.total_amount
    amount = 0
    Reservation.all.each do |reservation|
      if reservation.paid
        amount += reservation.total_price
      elsif reservation.prepaid
        amount += reservation.prepayment
      end
    end
    amount
  end
end
