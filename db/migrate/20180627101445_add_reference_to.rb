class AddReferenceTo < ActiveRecord::Migration[5.1]
  def change
    add_reference :reservations, :room, index: true
    add_reference :reservations, :client, index: true
    add_column :reservations, :paid, :boolean
  end
end
