class AddTypeOfRoomToRoom < ActiveRecord::Migration[5.1]
  def change
    add_column :rooms, :type_of_room, :integer, null: false, default: 0
  end
end
