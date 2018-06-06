class CreateReservations < ActiveRecord::Migration[5.1]
  def change
    create_table :reservations do |t|
      t.datetime :date_from, null:false
      t.datetime :date_to, null:false
      t.float :total_price

      t.timestamps
    end
  end
end
