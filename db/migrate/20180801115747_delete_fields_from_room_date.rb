class DeleteFieldsFromRoomDate < ActiveRecord::Migration[5.1]
  def change
    remove_column :room_dates, :number
    remove_column :room_dates, :price
  end
end
