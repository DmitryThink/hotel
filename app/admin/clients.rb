ActiveAdmin.register Client do
  permit_params :name, :surname, :phone_number, :email

  index do
    selectable_column
    column :name
    column :surname
    column :phone_number
    column :email
    actions
  end


end
