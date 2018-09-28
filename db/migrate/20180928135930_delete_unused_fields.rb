class DeleteUnusedFields < ActiveRecord::Migration[5.1]
  def change
    remove_column :months, :name, :string
    remove_column :months, :max_days, :integer
  end
end
