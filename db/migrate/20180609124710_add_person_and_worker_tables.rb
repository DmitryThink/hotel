class AddPersonAndWorkerTables < ActiveRecord::Migration[5.1]
  def change
    create_table :workers do |t|
      t.references :workable, polymorphic: true, index: true

      t.timestamps
    end

    create_table :people do |t|
      t.string :name, null: false
      t.string :surname, null: false
      t.references :personable, polymorphic: true, index: true

      t.timestamps
    end
  end
end
