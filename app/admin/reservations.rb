ActiveAdmin.register Reservation do
  permit_params :date_from, :date_to, :total_price, :client, :room, :price

  index do
    selectable_column
    column :date_from
    column :date_to
    column :client
    column :room
    column :price
    actions
  end

  member_action :reservations_paid, method: [:get, :post] do
    resource.update_attributes(
        paid: !resource.paid
    )
    redirect_to admin_client_url(resource.client.id)
  end

end
