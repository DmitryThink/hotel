class ChangeReservationPaidColumns < ActiveRecord::Migration[5.1]
  def change
    change_column :reservations, :prepaid, :boolean, default: false
    change_column :reservations, :paid, :boolean, default: false
  end
end
