class AddManyToManyTables < ActiveRecord::Migration[5.1]
  def change
    create_join_table :reservations, :visitors do |t|
      t.index [:reservation_id, :visitor_id]
    end

    create_join_table :trips, :visitors do |t|
      t.index [:trip_id, :visitor_id]
    end

    create_join_table :rooms, :maids do |t|
      t.index [:room_id, :maid_id]
    end

    create_join_table :meals, :cooks do |t|
      t.index [:meal_id, :cook_id]
    end

    create_join_table :orders, :meals do |t|
      t.index [:order_id, :meal_id]
    end
  end
end
