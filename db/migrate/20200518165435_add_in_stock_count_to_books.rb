class AddInStockCountToBooks < ActiveRecord::Migration[6.0]
  def change
    add_column :books, :in_stock, :integer, null: false, default: 0
  end
end
