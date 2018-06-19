ActiveAdmin.register Driver do
  permit_params :name, :surname, :salary, :license

  index do
    selectable_column
    column :name
    column :surname
    column :salary
    column :license
    actions
  end

  index do
    attributes_table do
      row :name
      row :surname
      row :salary
      row :license
    end

  end

  form do |f|
    f.inputs Order.model_name.human do
      f.input :name
      f.input :surname
      f.input :salary
    end

    f.submit
  end

  controller do
    def update

      redirect_to admin_driver_url(params[:id])
    end

    def create
      driver_params = params[:driver]
      driver = Driver.create!(salary: driver_params[:salary])
      worker = Worker.create!(workable: driver)
      Person.create!(name: driver_params[:name], surname: driver_params[:name], personable: worker)
      redirect_to admin_driver_url(driver.id)
    end
  end

end
