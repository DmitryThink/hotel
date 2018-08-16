class Reservation < ApplicationRecord
  validates :date_from, :date_to, presence: true
  validate :busy_dates, :dates_validation, :dates_3_days_validation, unless: :prepaid, if: :reservation_new?
  validate :prepaid_true, if: :paid

  delegate :name, :surname, :phone_number, :email, to: :client, allow_nil: true
  delegate :type_of_room, :type_of_room_ru, to: :room, allow_nil: true

  belongs_to :client
  belongs_to :room
  has_many :reservations_room_dates
  has_many :room_dates, through: :reservations_room_dates

  after_save :calculate_paid_prepaid
  after_save :calculate_month, if: :saved_change_to_prepaid?
  after_save :update_year_of_system

  before_destroy do
    ActiveRecord::Base.transaction do
      if prepaid
        calculate_month_(1)
      end
    end
  end

  def reservation_new?
    created_at == updated_at
  end

  def calculate_month
    ActiveRecord::Base.transaction do
      if prepaid
        calculate_month_(-1)
      else
        calculate_month_(1)
      end
    end
  end

  def calculate_month_(change_number)
    month_from = date_from.strftime("%m").to_i
    month_to = date_to.strftime("%m").to_i
    day_from = date_from.strftime("%d").to_i
    day_to = date_to.strftime("%d").to_i
    if change_number < 0
      check_in = RoomDate.find_or_create_by(date: date_from, room: room)
      check_out = RoomDate.find_or_create_by(date: date_to, room: room)
      ReservationsRoomDate.create!(check: "check_in", room_date: check_in, reservation: self)
      ReservationsRoomDate.create!(check: "check_out", room_date: check_out, reservation: self)
    else
      check_in = RoomDate.find_by(date: date_from, room: room)
      check_out = RoomDate.find_by(date: date_to, room: room)
      rrd1 = ReservationsRoomDate.find_by(check: "check_in", room_date: check_in, reservation: self)
      rrd2 = ReservationsRoomDate.find_by(check: "check_out", room_date: check_out, reservation: self)
      rrd1.destroy! if rrd1.present?
      rrd2.destroy! if rrd2.present?
      check_in.destroy if check_in.reservations_room_dates.count == 0 if check_in.present?
      check_out.destroy if check_out.reservations_room_dates.count == 0 if check_out.present?
    end
    (month_from..month_to).each do |month_number|
      month = Month.find_by(number: month_number, room: room)
      days = {}
      count = day_from
      if month_number == month_to
        to = day_to
      else
        to = month.max_days+1
      end
      month.days?(day_from, to-1).each do |day_number|
        raise "month exp" if day_number == 0 && change_number < 0
        day_number = day_number + change_number
        days.merge!("day_#{count}": day_number)
        count+=1
      end
      month.update!(days)
      day_from = 1
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
    month_from = date_from.strftime("%m").to_i
    month_to = date_to.strftime("%m").to_i
    day_from = date_from.strftime("%d").to_i
    day_to = date_to.strftime("%d").to_i
    (month_from..month_to).each do |month_number|
      month = Month.find_by(number: month_number, room: room)
      if month.nil? || month.busy_dates?(day_from, day_to)
        errors.add(:base, "У нас не осталось дат на эти дни! Попробуйте другие")
      end
      date_from_count = date_from
      if month_number == month_to
        to = day_to
      else
        to = month.max_days+1
      end
      month.days?(day_from, to-1).each do |number|
        if Reservation.where("created_at > ?", 42.minutes.ago).where(prepaid:false).where("? between date_from and (date_to - INTERVAL '1 DAY')", date_from_count).count >= number
          errors.add(:base, "У нас не осталось дат на эти дни! Попробуйте другие")
        end
        date_from_count = date_from_count + 1.day
      end
      day_from = 1
    end
  end

  def calculate_total_price
    price = 0
    month_from = date_from.strftime("%m").to_i
    month_to = date_to.strftime("%m").to_i
    day_from = date_from.strftime("%d").to_i
    day_to = date_to.strftime("%d").to_i
    (month_from..month_to).each do |month_number|
      month = Month.find_by(number: month_number, room: room)
      if month_number == month_to
        to = day_to
      else
        to = month.max_days+1
      end
      price += (to-day_from) * month.price
      day_from = 1
    end
    self.total_price = price
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

  def update_year_of_system
    reservation = Reservation.all.first
    if (reservation.present? && reservation.date_from.strftime("%Y") != Time.now.year.to_s) || reservation.blank?
      Scr::GenerateMonth.new.process!
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
