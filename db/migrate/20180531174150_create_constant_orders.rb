class CreateConstantOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :constant_orders do |t|
      t.datetime :time, null:false
      t.float :price
      t.datetime :date_from
      t.datetime :date_to

      t.timestamps
    end
  end
end
