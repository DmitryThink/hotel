class AddPrepaidToReservation < ActiveRecord::Migration[5.1]
  def change
    add_column :reservations, :prepaid, :boolean
  end
end
