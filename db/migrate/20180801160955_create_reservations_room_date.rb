class CreateReservationsRoomDate < ActiveRecord::Migration[5.1]
  def change
    create_table :reservations_room_dates do |t|
      t.integer :check
      t.references :reservation, foreign_key: true
      t.references :room_date, foreign_key: true

      t.timestamps
    end
  end
end
