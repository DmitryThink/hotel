class DeletePriceFromOrder < ActiveRecord::Migration[5.1]
  def change
    remove_column :orders, :price
  end
end
