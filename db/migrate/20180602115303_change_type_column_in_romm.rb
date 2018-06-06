class ChangeTypeColumnInRomm < ActiveRecord::Migration[5.1]
  def change
    rename_column :rooms, :type, :status
  end
end
