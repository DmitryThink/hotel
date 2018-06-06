class CreateDrivers < ActiveRecord::Migration[5.1]
  def change
    create_table :drivers do |t|
      t.string :name, null:false
      t.string :surname, null:false
      t.float :salary, null:false
      t.string :license

      t.timestamps
    end
  end
end
