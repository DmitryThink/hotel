ActiveAdmin.register Message do
  actions :index, :destroy

  index do
    selectable_column
    column :name
    column :phone_number
    column :message
    column :created_at
    actions
  end
end
