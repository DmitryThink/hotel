class AddMessageToReservation < ActiveRecord::Migration[5.1]
  def change
    add_column :reservations, :message, :string
  end
end
