ActiveAdmin.register Reservation do
  permit_params :date_from, :date_to, :total_price, :client, :room, :message
  actions :show, :index, :destroy

  index do
    selectable_column
    column :date_from do |r|
      r.date_from.strftime("%d-%m-%y %A")
    end
    column :date_to do |r|
      r.date_to.strftime("%d-%m-%y %A")
    end
    column :client
    column :room
    column :message
    column :prepayment
    column :prepayment_status do |reservation|
      link_to("#{ reservation.prepaid ? "Оплачено" : "Не оплачено" }",
              reservations_prepaid1_admin_reservation_url(reservation.id),
              method: :post)
    end
    column :total_price
    column :payment_status do |reservation|
      link_to("#{ reservation.paid ? "Оплачено" : "Не оплачено" }",
              reservations_paid1_admin_reservation_url(reservation.id),
              method: :post)
    end
    column :created_at
    actions
  end

  show do
    attributes_table do
      row :date_from do |r|
        r.date_from.strftime("%d-%m-%y %A")
      end
      row :date_to do |r|
        r.date_to.strftime("%d-%m-%y %A")
      end
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

  member_action :reservations_paid1, method: :post do
    begin
      ActiveRecord::Base.transaction do
        if !resource.prepaid
          resource.update!(prepaid: !resource.prepaid)
        end
        resource.update!(paid: !resource.paid)
      end
    rescue
    end
    redirect_to admin_reservations_url
  end

  member_action :reservations_prepaid1, method: :post do
    begin
      ActiveRecord::Base.transaction do
        resource.update!(prepaid: !resource.prepaid)
      end
    rescue
    end
    redirect_to admin_reservations_url
  end
end
