class CreateReservationsTable < ActiveRecord::Migration[6.0]
  def change
    create_table :reservations do |t|
      t.references :book, null: false
      t.timestamp :expires_at, null: false
    end

    add_foreign_key :reservations, :books
    add_index :reservations, :expires_at
  end
end
