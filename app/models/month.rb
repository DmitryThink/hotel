class Month < ApplicationRecord
  belongs_to :room

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

  def update_all
    number = room.number
    days = {}
    (1..max_days).each do |count|
      days.merge!("day_#{count}": number)
    end
    update!(days)
  end

  def name_ru
    case name
      when "May"
        "Май"
      when "June"
        "Июнь"
      when "July"
        "Июль"
      when "August"
        "Август"
      when "September"
        "Сентрябрь"
    end
  end
end
