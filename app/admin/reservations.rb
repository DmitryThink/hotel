ActiveAdmin.register Reservation do
  permit_params :date_from, :date_to, :total_price, :client, :room

  index_as_calendar

  index do
    selectable_column
    column :date_from
    column :date_to
    column :total_price
    column :client
    column :room
    actions
  end


end
