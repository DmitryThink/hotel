ActiveAdmin.register Room do
  actions :index, :show
  permit_params :number, :number_of_people, :type_of_room, :status, :price
  index do
    selectable_column
    column :number
    column :number_of_people
    column :type_of_room
    actions
  end

  show do
    attributes_table do
      row :number
      row :number_of_people
      row :type_of_room
    end
    tabs do
      mon = {Май: 5, Июнь: 6, Июль: 7, Август: 8, Сентябрь: 9}
      {Сейчас: Time.now.month}.merge(mon).each do |k, v|
      tab k do
        table_for(room.room_dates.where('extract(month from date) = ?', v).order(:date)) do
          column :today do |room_date|
            if room_date.date == Date.today
              'сейчас'
            end
          end
          column :price
          column :date do |room_date|
            if room_date.date.strftime("%A") == "Saturday" || room_date.date.strftime("%A") == "Sunday"
              strong do
                link_to(room_date.date.strftime("%d-%m-%y %A"), admin_room_date_url(room_date.id))
              end
            else
              link_to(room_date.date.strftime("%d-%m-%y %A"), admin_room_date_url(room_date.id))
            end
          end
          column :number
          column :check_in_list
          column :check_out_list
        end
      end
      end
      tab :Все_даты do
        table_for(room.room_dates.order(:date))  do
          column :today do |room_date|
            if room_date.date == Date.today
              'сейчас'
            end
          end
          column :price
          column :date do |room_date|
            if room_date.date.strftime("%A") == "Saturday" || room_date.date.strftime("%A") == "Sunday"
              strong do
                link_to(room_date.date.strftime("%d-%m-%y %A"), admin_room_date_url(room_date.id))
              end
            else
              link_to(room_date.date.strftime("%d-%m-%y %A"), admin_room_date_url(room_date.id))
            end
          end
          column :number
          column :check_in_list
          column :check_out_list
        end
      end
    end
  end
end

