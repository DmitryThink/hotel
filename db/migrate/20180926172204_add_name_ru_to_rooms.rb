class AddNameRuToRooms < ActiveRecord::Migration[5.1]
  def change
    add_column :rooms, :name_ru, :string
  end
end
