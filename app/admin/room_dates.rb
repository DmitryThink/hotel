ActiveAdmin.register RoomDate do
  actions :index, :show

  index do
    column :date
    column :number
    column :price
    column :room
  end

  show do
    attributes_table do
      row :id
      row :date
      row :number
    end

    tabs do
      {Заезды: room_date.check_in, Отъезды: room_date.check_out, Все: room_date.reservations}.each do |k, v|
        tab k do
          table_for(v) do
            column :id do |reservation|
              link_to(reservation.id, admin_reservation_url(reservation.id))
            end
            column :name
            column :surname
            column :phone_number
            column :room
          end
        end
      end
    end
  end
end