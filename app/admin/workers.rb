ActiveAdmin.register Worker do
  permit_params :name, :surname, :personable, :person

  index do
    selectable_column
    column :name
    column :surname
    column :personable
    column :person
    actions
  end
end
