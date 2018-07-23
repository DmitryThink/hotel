ActiveAdmin.register Reservation do
  permit_params :date_from, :date_to, :total_price, :client, :room, :message

  index do
    selectable_column
    column :date_from
    column :date_to
    column :total_price
    column :client
    column :room
    column :message
    column :paid
    column :prepaid
    actions
  end

  show do
    attributes_table do
      row :date_from
      row :date_to
      row :total_price
      row :client
      row :room
      row :message
    end
    panel :dates do
      table_for(reservation.room_dates.order(:date))  do
        column :price
        column :number
        column :date do |room_date|
          if room_date.date.strftime("%A") == "Saturday" || room_date.date.strftime("%A") == "Sunday"
            strong do
              link_to(room_date.date.strftime("%d-%m-%y %A"), admin_room_date_url(room_date.id))
            end
          else
            link_to(room_date.date.strftime("%d-%m-%y %A"), admin_room_date_url(room_date.id))
          end
        end
      end
    end
  end

  member_action :reservations_paid, method: :post do
    begin
    ActiveRecord::Base.transaction do
      if !resource.prepaid
        resource.update!(prepaid: !resource.prepaid)
      end
      resource.update!(paid: !resource.paid)
    end
    rescue
    end
    redirect_to admin_client_url(resource.client.id)
  end

  member_action :reservations_prepaid, method: :post do
    begin
    ActiveRecord::Base.transaction do
      resource.update!(prepaid: !resource.prepaid)
    end
    rescue
    end
    redirect_to admin_client_url(resource.client.id)
  end
end
