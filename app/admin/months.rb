ActiveAdmin.register Month do
  actions :index, :edit, :show
  controller do
    def update
      Month.find(params['id']).update!(params['month'].permit!)
      redirect_to admin_month_url(params['id'])
    end
  end
end
