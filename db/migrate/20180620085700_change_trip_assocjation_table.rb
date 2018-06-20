class ChangeTripAssocjationTable < ActiveRecord::Migration[5.1]
  def change
    create_join_table :trips, :people do |t|
      t.index [:trip_id, :person_id]
    end

    drop_join_table :trips, :visitors do |t|
      t.index [:trip_id, :visitor_id]
    end
  end
end
