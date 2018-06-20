ActiveAdmin.register Worker do
  actions :index, :show
  permit_params :name, :surname, :workable_type, :workable

  index do
    selectable_column
    column :name
    column :surname
    column :workable_type
    column :workable
    actions
  end



end
