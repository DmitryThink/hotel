class CreateTrips < ActiveRecord::Migration[5.1]
  def change
    create_table :trips do |t|
      t.datetime :time
      t.float :price

      t.timestamps
    end
  end
end
