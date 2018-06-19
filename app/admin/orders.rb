ActiveAdmin.register Order do
  permit_params :time, :price, :reservation

  index do
    selectable_column
    column :time
    column :price
    column :reservation
    actions
  end

  show do
    attributes_table do
      row :time
      row :price
      row :reservation
      row :add_meal  do |order|
        link_to("add", add_meal_admin_order_url(order.id))
      end
    end
    panel :meals do
      table_for(order.meals) do
        column :name
        column :price
        # column :delete_meal do |meal|
        #   link_to "delete", delete_meal_admin_order_url(meal.id), method: :post
        # end
      end
    end
  end

  form do |f|
    f.inputs Order.model_name.human do
      f.input :reservation, as: :select, collection: Reservation.all
    end

    f.submit
  end

  controller do
    def update
      Order.find(params[:id]).update!(reservation_id: params[:order][:reservation_id], time: DateTime.now)
      redirect_to admin_order_url(params[:id])
    end

    def create
      order = Order.create!(reservation_id: params[:order][:reservation_id], time: DateTime.now)
      redirect_to admin_order_url(order.id)
    end
  end

  member_action :add_meal, method: [:get, :post] do
    if request.post?
      order = params.require(:order)
      resource.meals << Meal.find(order[:meals])
      resource.save
      redirect_to admin_order_url(resource.id)
    else
      @order = resource
      render
    end
  end
  #
  # member_action :delete_meal, method: [:post] do
  #   byebug
  #   resource.meals.delete(Meal.find(params[:id]))
  #   resource.save!
  #   redirect_to admin_order_url(resource.id)
  # end
end
