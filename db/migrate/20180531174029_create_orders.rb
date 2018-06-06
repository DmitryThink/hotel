class CreateOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :orders do |t|
      t.datetime :time, null:false
      t.float :price

      t.timestamps
    end
  end
end
