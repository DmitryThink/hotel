ActiveAdmin.register Client do
  permit_params :name, :surname, :phone_number, :email

  index do
    selectable_column
    column :name
    column :surname
    column :phone_number
    column :email
    column :created_at
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
      table_for(client.reservations.order(:id)) do
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
      f.input :email
      f.input :date_from, :as => :date_picker
      f.input :date_to, as: :date_picker
      f.input :type_of_room,  :label => 'type_of_room', :as => :select, :collection => Room.all.map{|u| ["#{u.type_of_room}", u.type_of_room]}
    end
    f.actions
  end

  controller do
    def create
      ActiveRecord::Base.transaction do
        @client = Client.find_by(client_params) || Client.new(client_params)
        @reservation = Reservation.new(reservation_params)
        @room = Room.find_by(type_of_room: type_of_room.downcase)
        @reservation.client = @client
        @reservation.room = @room
        calculate_total_price
        @reservation.save!
        redirect_to admin_client_url(@client.id)
      end
    end
    
    private

    def calculate_total_price
      date_from = @reservation.date_from
      date_to = @reservation.date_to
      price = 0
      if date_from.present? && date_to.present?
        sd = Date.parse(date_from.to_s)
        ed = Date.parse(date_to.to_s) - 1.day
        sd.upto(ed).each do |date|
          room_date = RoomDate.find_by(date: date, room: @reservation.room)
          price += room_date.price
        end
      end
      @reservation.total_price = price
    end

    def reservation_params
      params.require(:client).permit(:date_from, :date_to, :message)
    end

    def client_params
      prms = params.require(:client).permit(:name, :surname, :phone_number, :email)
      prms[:email] = prms[:email].downcase
      prms[:phone_number] = prms[:phone_number].gsub!(/[\-|\)|\(| ]/, '') || prms[:phone_number]
      prms[:phone_number] = prms[:phone_number][2..-1] if prms[:phone_number][0..2] == "380"
      prms[:phone_number] = prms[:phone_number][3..-1] if prms[:phone_number][0..3] == "+380"
      prms[:name] = capitalize(prms[:name])
      prms[:surname] = capitalize(prms[:surname])
      prms
    end

    def capitalize(str)
      str[0].mb_chars.upcase.to_s + str[1..-1]
    end

    def type_of_room
      params[:client][:type_of_room]
    end
  end
end
