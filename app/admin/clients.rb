ActiveAdmin.register Client do
  permit_params :name, :surname, :phone_number, :email, :price

  index do
    selectable_column
    column :name
    column :surname
    column :phone_number
    column :email
    actions
  end


  show do
    attributes_table do
      row :id
      row :name
      row :surname
      row :phone_number
      row :email
    end
    panel :reservations do
      table_for(client.reservations) do
        column :id
        column :date_from
        column :date_to
        column :room
        column :price
        column :reservations_paid do |reservation|
          link_to("#{ reservation.paid ? "Unpaid" : "Paid" }",
                  reservations_paid_admin_reservation_url(reservation.id))
        end
      end
    end
  end

end
