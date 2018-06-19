ActiveAdmin.register Cook do
  permit_params :name, :surname, :salary, :education

  index do
    selectable_column
    column :name
    column :surname
    column :salary
    column :education
    actions
  end

  index do
    attributes_table do
      row :name
      row :surname
      row :salary
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

      redirect_to admin_cook_url(params[:id])
    end

    def create
      cook_params = params[:cook]
      cook = Cook.create!(salary: cook_params[:salary])
      worker = Worker.create!(workable: cook)
      Person.create!(name: cook_params[:name], surname: cook_params[:name], personable: worker)
      redirect_to admin_cook_url(cook.id)
    end
  end
end
