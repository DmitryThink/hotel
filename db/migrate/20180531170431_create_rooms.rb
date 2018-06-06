class CreateRooms < ActiveRecord::Migration[5.1]
  def change
    create_table :rooms do |t|
      t.integer :number, null:false
      t.integer :number_of_people, null:false
      t.float :price, null:false
      t.integer :type

      t.timestamps
    end
  end
end
