class AddSalesTable < ActiveRecord::Migration[6.0]
  def change
    create_table :sales do |t|
      t.datetime :placed_at
      t.integer :revenue
      t.integer :unit_price
      t.integer :quantity

      t.integer :order_line_item_id
      t.integer :order_id
      t.integer :book_id
      t.integer :author_id
      t.integer :buyer_id
      t.string :state, limit: 2
    end
  end
end
