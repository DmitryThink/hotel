ActiveAdmin.register Room do
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
      tab :june do
        table_for(room.room_dates.where('extract(month from date) = ?', 6).order(:date)) do
          column :price
          column :number
          column :date do |room_date|
            if room_date.date.strftime("%A") == "Saturday" || room_date.date.strftime("%A") == "Sunday"
              strong do
                link_to(room_date.date.strftime("%d-%m-%y %A"), admin_room_date_url(room_date.id))
              end
            else
              link_to(room_date.date.strftime("%d-%m-%y %A"), admin_room_date_url(room_date.id))
            end
          end
        end
      end
      tab :july do
        table_for(room.room_dates.where('extract(month from date) = ?', 7).order(:date))  do
          column :price
          column :number
          column :date do |room_date|
            if room_date.date.strftime("%A") == "Saturday" || room_date.date.strftime("%A") == "Sunday"
              strong do
                link_to(room_date.date.strftime("%d-%m-%y %A"), admin_room_date_url(room_date.id))
              end
            else
              link_to(room_date.date.strftime("%d-%m-%y %A"), admin_room_date_url(room_date.id))
            end
          end
        end
      end
      tab :august do
        table_for(room.room_dates.where('extract(month from date) = ?', 8).order(:date))  do
          column :price
          column :number
          column :date do |room_date|
            if room_date.date.strftime("%A") == "Saturday" || room_date.date.strftime("%A") == "Sunday"
              strong do
                link_to(room_date.date.strftime("%d-%m-%y %A"), admin_room_date_url(room_date.id))
              end
            else
              link_to(room_date.date.strftime("%d-%m-%y %A"), admin_room_date_url(room_date.id))
            end
          end
        end
      end
      tab :september do
        table_for(room.room_dates.where('extract(month from date) = ?', 9).order(:date))  do
          column :price
          column :number
          column :date do |room_date|
            if room_date.date.strftime("%A") == "Saturday" || room_date.date.strftime("%A") == "Sunday"
              strong do
                link_to(room_date.date.strftime("%d-%m-%y %A"), admin_room_date_url(room_date.id))
              end
            else
              link_to(room_date.date.strftime("%d-%m-%y %A"), admin_room_date_url(room_date.id))
            end
          end
        end
      end
      tab :all do
        table_for(room.room_dates.order(:date))  do
          column :price
          column :number
          column :date do |room_date|
            if room_date.date.strftime("%A") == "Saturday" || room_date.date.strftime("%A") == "Sunday"
              strong do
                link_to(room_date.date.strftime("%d-%m-%y %A"), admin_room_date_url(room_date.id))
              end
            else
              link_to(room_date.date.strftime("%d-%m-%y %A"), admin_room_date_url(room_date.id))
            end
          end
        end
      end
    end
  end
end

