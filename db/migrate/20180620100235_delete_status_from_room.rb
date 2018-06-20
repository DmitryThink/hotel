class DeleteStatusFromRoom < ActiveRecord::Migration[5.1]
  def change
    remove_column :rooms, :status
  end
end
