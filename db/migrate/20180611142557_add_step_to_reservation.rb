class AddStepToReservation < ActiveRecord::Migration[5.1]
  def change
    add_column :reservations, :step, :string
  end
end
