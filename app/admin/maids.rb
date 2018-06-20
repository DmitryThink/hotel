ActiveAdmin.register Maid do
  permit_params :name, :surname, :salary

  index do
    selectable_column
    column :name
    column :surname
    column :salary
    actions
  end

  show do
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
      maid_params = params[:maid]
      maid = Maid.find(params[:id])
      maid.worker.update!(workable: maid, salary: maid_params[:salary])
      maid.worker.person.update!(name: maid_params[:name], surname: maid_params[:name])
      redirect_to admin_maid_url(params[:id])
    end

    def create
      maid_params = params[:maid]
      maid = Maid.create!
      worker = Worker.create!(workable: maid, salary: maid_params[:salary])
      Person.create!(name: maid_params[:name], surname: maid_params[:name], personable: worker)
      redirect_to admin_maid_url(maid.id)
    end
  end
end
