ActiveAdmin.register Room do
  actions :index, :show
  permit_params :number, :number_of_people, :name, :status, :price
  index do
    selectable_column
    column :number
    column :number_of_people
    column :name
    actions
  end

  show do
    attributes_table do
      row :number
      row :number_of_people
      row :name
    end

    panel :month do
      table_for(room.months.order(:number)) do
        column :name do |month|
          link_to(month.name_ru, admin_month_url(month.id))
        end
        (1..31).each do  |i|
          column :"day_#{i}" do |month|
            if month.send("day_#{i}").present?
              date =  DateTime.parse("#{i}.#{month.number}.2018")
              room_date = RoomDate.find_by(room: month.room, date: date)
              day = "#{month.send("day_#{i}")}"
              if  date.strftime("%A") == "Saturday" ||  date.strftime("%A") == "Sunday"
                strong do
                  if room_date.present?
                    link_to(day, admin_room_date_url(room_date))
                  else
                    day
                  end
                end
              else
                if room_date.present?
                  link_to(day, admin_room_date_url(room_date))
                else
                  day
                end
              end
            end
          end
        end
      end
    end

    panel :check_in do
      table_for(room.reservations.where(date_from: Time.now)) do
        column :client
        column :room
        column :message
        column :prepayment
      end
    end

    panel :check_out do
      table_for(room.reservations.where(date_to: Time.now)) do
        column :client
        column :room
        column :message
        column :prepayment
      end
    end
  end
end

