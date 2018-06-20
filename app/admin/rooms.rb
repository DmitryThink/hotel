ActiveAdmin.register Room do
  permit_params :number, :number_of_people, :type_of_room, :status, :price
  index do
    selectable_column
    column :number
    column :number_of_people
    column :type_of_room
    column :status
    column :price
    column :reservations
    actions
  end
end
