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
    panel :reservations do
      table_for(room_date.reservations) do
        column :id
        column :date_from
        column :date_to
        column :room
        column :reservations_paid do |reservation|
          link_to("#{ reservation.paid ? "Unpaid" : "Paid" }",
                  reservations_paid_admin_reservation_url(reservation.id),
                  method: :post)
        end
      end
    end
  end
end