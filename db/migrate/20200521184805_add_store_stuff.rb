class AddStoreStuff < ActiveRecord::Migration[6.0]
  def change
    create_table :buyers do |t|
      t.string :email, null: false
      t.timestamps null: false
    end

    create_table :shipping_addresses do |t|
      t.string :state
      t.belongs_to :buyer, null: false
      t.timestamps null: false
    end

    add_foreign_key :shipping_addresses, :buyers

    create_table :orders do |t|
      t.belongs_to :buyer, null: false
      t.belongs_to :shipping_address, null: false
      t.datetime :placed_at, null: false
      t.datetime :canceled_at, null: true
      t.timestamps null: false
    end

    add_foreign_key :orders, :buyers
    add_foreign_key :orders, :shipping_addresses

    create_table :order_line_items do |t|
      t.belongs_to :book, null: false
      t.belongs_to :order, null: false
      t.integer :unit_price, null: false
      t.integer :quantity, null: false
    end

    add_foreign_key :order_line_items, :orders
    add_foreign_key :order_line_items, :books
  end
end
