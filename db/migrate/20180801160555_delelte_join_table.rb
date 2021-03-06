class DelelteJoinTable < ActiveRecord::Migration[5.1]
  def change
    drop_join_table :reservations, :room_dates do |t|
      t.index [:reservation_id, :room_date_id], :name => 'reservations_room_dates_index'
    end
  end
end
