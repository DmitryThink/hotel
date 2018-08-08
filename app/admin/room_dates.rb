ActiveAdmin.register RoomDate do
  actions :index, :show

  index do
    column :date
    column :room
  end

  show do
    attributes_table do
      row :id
      row :date
    end

    tabs do
      panel :check_in do
        table_for(room_date.reservations_room_dates.where(check: "check_in")) do
          column :reservation
        end
      end

      panel :check_out do
        table_for(room_date.reservations_room_dates.where(check: "check_out")) do
          column :reservation
        end
      end
    end
  end
end