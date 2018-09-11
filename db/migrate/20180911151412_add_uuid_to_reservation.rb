class AddUuidToReservation < ActiveRecord::Migration[5.1]
  def change
    enable_extension 'uuid-ossp'
    add_column :reservations, :uuid, :uuid, default: 'uuid_generate_v4()'
  end
end
