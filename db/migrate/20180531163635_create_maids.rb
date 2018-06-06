class CreateMaids < ActiveRecord::Migration[5.1]
  def change
    create_table :maids do |t|
      t.string :name, null: false
      t.string :surname, null: false
      t.float :salary, null: false

      t.timestamps
    end
  end
end
