class CreateVisitors < ActiveRecord::Migration[5.1]
  def change
    create_table :visitors do |t|
      t.string :name, null: false
      t.string :surname, null: false

      t.timestamps
    end
  end
end
