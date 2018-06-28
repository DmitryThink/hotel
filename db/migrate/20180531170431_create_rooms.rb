class CreateRooms < ActiveRecord::Migration[5.1]
  def change
    create_table :rooms do |t|
      t.integer :number, null:false
      t.integer :number_of_people, null:false
      t.integer :type_of_room

      t.timestamps
    end
  end
end
