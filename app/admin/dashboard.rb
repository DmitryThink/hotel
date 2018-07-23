ActiveAdmin.register_page "Dashboard" do

  menu priority: 1, label: proc{ Reservation.total_amount.to_i.to_s + " грн" }

end
