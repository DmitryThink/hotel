ActiveAdmin.register Trip do
  permit_params :time, :price, :driver, :place

  form do |f|
    f.inputs Trip.model_name.human do
      f.input :time
      f.input :price
      f.input :driver, as: :select, collenction: Driver.all
      f.input :place, as: :select, collection: Place.all
    end

    f.submit
  end

  controller do
    def update
      Trip.find(params[:id]).update!(
          time: params[:trip][:time],
          price: params[:trip][:price],
          driver: Driver.find(params[:trip][:driver_id]),
          place: Place.find(params[:trip][:place_id]),
          )
      redirect_to admin_trip_url(params[:id])
    end

    def create
      trip = Trip.create!(
          time: params[:trip][:time],
          price: params[:trip][:price],
          driver: Driver.find(params[:trip][:driver_id]),
          place: Place.find(params[:trip][:place_id]),
          )
      redirect_to admin_trip_url(trip.id)
    end
  end
end
