class Month < ApplicationRecord
  belongs_to :room

  after_create :fill_days

  def days?(from, to)
    days[from-1..to-1]
  end

  def days
    days = []
    attributes.each_pair do
      |k,v| days << v if k[0..2] == "day"
    end
    days
  end

  def busy_dates?(from, to)
    days?(from,to).any? { |c| c == 0 }
  end

  def fill_days
    days = {}
    (1..max_days).each do |count|
      days.merge!("day_#{count}": room.number)
    end
    update!(days)
  end

  def self.update_all
    Month.all.each do |month|
      month.fill_days
    end
  end

  def disable_dates
    disable_dates_list = []
    (1..max_days).each do |day_number|
      disable_dates_list << "#{Time.now.year}.#{number}.#{day_number}".to_date.strftime('%Y-%m-%d') if send("day_#{day_number}") == 0
    end
    disable_dates_list
  end

  def self.disable_dates(room_name)
    months = Room.find_by(name: room_name).months
    disable_dates_list = []
    months.each do |month|
      disable_dates_list =  disable_dates_list + month.disable_dates
    end
    disable_dates_list
  end

  def self.start_month
    5
  end

  def self.end_month
    10
  end

  def name
    { '5': 'May', '6': 'June', '7': 'July', '8': 'August', '9': 'September', '10': 'October' }[:"#{number}"]
  end

  def name_ru
    { '5': 'Май', '6': 'Июнь', '7': 'Июль', '8': 'Август', '9': 'Сентябрь', '10': 'Октябрь' }[:"#{number}"]
  end

  def max_days
    { '5': 31, '6': 30, '7': 31, '8': 31, '9': 30, '10': 31 }[:"#{number}"]
  end
end
