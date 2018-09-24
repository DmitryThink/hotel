ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: proc{ "Заработано: #{ Reservation.total_amount.to_i.to_s } грн.\n Посещений: #{ Click.where(location: "book", created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day).count }.\n Кликов: #{ Click.where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day).count }." }

  content title: proc { I18n.t("active_admin.dashboard") } do
    text_node "Всего посещений: #{Click.where(location: "book").count}"
    br
    text_node "Всего кликов: #{Click.count}"
  end
end
