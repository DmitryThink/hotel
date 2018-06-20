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

  show do
    attributes_table do
      row :name
      row :surname
      row :salary
      row :education
    end

  end

  form do |f|
    f.inputs Order.model_name.human do
      f.input :name
      f.input :surname
      f.input :salary
      f.input :education
    end

    f.submit
  end

  controller do
    def update
      cook_params = params[:cook]
      cook = Cook.find(params[:id])
      cook.update!(education: cook_params[:education])
      cook.worker.update!(workable: cook, salary: cook_params[:salary])
      cook.worker.person.update!(name: cook_params[:name], surname: cook_params[:name])
      redirect_to admin_cook_url(params[:id])
    end

    def create
      cook_params = params[:cook]
      cook = Cook.create!(education: cook_params[:education])
      worker = Worker.create!(workable: cook)
      Person.create!(name: cook_params[:name], surname: cook_params[:name], personable: worker)
      redirect_to admin_cook_url(cook.id)
    end
  end
end
