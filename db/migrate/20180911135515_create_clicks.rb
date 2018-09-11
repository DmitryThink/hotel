class CreateClicks < ActiveRecord::Migration[5.1]
  def change
    create_table :clicks do |t|
      t.string :location

      t.timestamps
    end
  end
end
