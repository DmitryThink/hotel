ActiveAdmin.register Room do
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
# permit_params :list, :of, :attributes, :on, :model
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_user.admin?
#   permitted
# end
#
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
