class DeleteNameAndSurnameFromTables < ActiveRecord::Migration[5.1]
  def change
    remove_column :clients, :name
    remove_column :clients, :surname
    remove_column :visitors, :name
    remove_column :visitors, :surname
    remove_column :maids, :name
    remove_column :maids, :surname
    remove_column :cooks, :name
    remove_column :cooks, :surname
    remove_column :drivers, :name
    remove_column :drivers, :surname
  end
end
