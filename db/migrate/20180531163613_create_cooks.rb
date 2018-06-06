class CreateCooks < ActiveRecord::Migration[5.1]
  def change
    create_table :cooks do |t|
      t.string :name, null:false
      t.string :surname, null:false
      t.float :salary, null:false
      t.string :education

      t.timestamps
    end
  end
end
