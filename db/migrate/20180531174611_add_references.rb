class AddReferences < ActiveRecord::Migration[5.1]
  def change
    add_reference :reservations, :client, book:true
    add_reference :reservations, :room, book:true
    add_reference :orders, :reservation, book:true
    add_reference :trips, :driver, book:true
  end
end
