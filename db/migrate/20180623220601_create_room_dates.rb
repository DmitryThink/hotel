class CreateRoomDates < ActiveRecord::Migration[5.1]
  def change
    create_table :room_dates do |t|
      t.date :date
      t.integer :number
      t.float :price
      t.references :room, foreign_key: true

      t.timestamps
    end
  end
end
