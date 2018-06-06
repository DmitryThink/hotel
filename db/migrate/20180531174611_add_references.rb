class AddReferences < ActiveRecord::Migration[5.1]
  def change
    add_reference :reservations, :client, index:true
    add_reference :reservations, :room, index:true
    add_reference :orders, :reservation, index:true
    add_reference :trips, :driver, index:true
  end
end
