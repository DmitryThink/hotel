ActiveAdmin.register Client do
  permit_params :name, :surname, :phone_number, :email

  index do
    selectable_column
    column :name
    column :surname
    column :phone_number
    column :email
    actions
  end

  show do
    attributes_table do
      row :id
      row :name
      row :surname
      row :phone_number
      row :email
    end
    panel :reservations do
      table_for(client.reservations) do
        column :id do |reservation|
          link_to(reservation.id, admin_reservation_url(reservation.id))
        end
        column :date_from
        column :date_to
        column :room
        column :message
        column :prepayment
        column :prepayment_status do |reservation|
          link_to("#{ reservation.prepaid ? "Оплачено" : "Не оплачено" }",
                  reservations_prepaid_admin_reservation_url(reservation.id),
                  method: :post)
        end
        column :total_price
        column :payment_status do |reservation|
          link_to("#{ reservation.paid ? "Оплачено" : "Не оплачено" }",
                  reservations_paid_admin_reservation_url(reservation.id),
                  method: :post)
        end
      end
    end
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :surname
      f.input :phone_number
      f.input :date_from, :as => :date_picker
      f.input :date_to, as: :date_picker
      f.input :type_of_room
    end
    f.actions
  end

  controller do
    def create
      ActiveRecord::Base.transaction do
        room = Room.find_by(type_of_room: params[:client][:type_of_room])
        client = Client.create!(name: params[:client][:name], surname: params[:client][:surname], phone_number: params[:client][:phone_number])

        sd = Date.parse(params[:client][:date_from])
        ed = Date.parse(params[:client][:date_to])
        price = 0
        sd.upto(ed).each do |date|
          room_date = RoomDate.find_by(date: date, room: room)
          room_date.number = room_date.number - 1
          room_date.reservations << reservation
          room_date.save!
          price += room_date.price
        end
        reservation = Reservation.create!(date_from: params[:client][:date_from], date_to: params[:client][:date_to], room: room, client: client, total_price: price)

        redirect_to admin_client_url(client.id)
      end
    end
  end
end
