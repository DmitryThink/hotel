class ChangeFieldsInRoom < ActiveRecord::Migration[5.1]
  def change
    change_column :rooms, :type_of_room, :string
    rename_column :rooms, :type_of_room, :name
  end
end
