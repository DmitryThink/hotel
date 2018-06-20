class ChangeSalaryToWorker < ActiveRecord::Migration[5.1]
  def change
    remove_column :maids, :salary
    remove_column :drivers, :salary
    remove_column :cooks, :salary
    add_column :workers, :salary, :float
  end
end
