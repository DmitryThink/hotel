class CreateMeals < ActiveRecord::Migration[5.1]
  def change
    create_table :meals do |t|
      t.string :name, null:false
      t.float :price, null:false

      t.timestamps
    end
  end
end
