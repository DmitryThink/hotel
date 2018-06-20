class AddPlaceToTrip < ActiveRecord::Migration[5.1]
  def change
    add_reference :trips, :place, book:true
  end
end
