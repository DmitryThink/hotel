class CreateMonths < ActiveRecord::Migration[5.1]
  def change
    create_table :months do |t|
      t.integer :number
      t.float :price
      t.string :name
      t.integer :max_days
      t.integer :day_1
      t.integer :day_2
      t.integer :day_3
      t.integer :day_4
      t.integer :day_5
      t.integer :day_6
      t.integer :day_7
      t.integer :day_8
      t.integer :day_9
      t.integer :day_10
      t.integer :day_11
      t.integer :day_12
      t.integer :day_13
      t.integer :day_14
      t.integer :day_15
      t.integer :day_16
      t.integer :day_17
      t.integer :day_18
      t.integer :day_19
      t.integer :day_20
      t.integer :day_21
      t.integer :day_22
      t.integer :day_23
      t.integer :day_24
      t.integer :day_25
      t.integer :day_26
      t.integer :day_27
      t.integer :day_28
      t.integer :day_29
      t.integer :day_30
      t.integer :day_31

      t.references :room, foreign_key: true

      t.timestamps
    end
  end
end
