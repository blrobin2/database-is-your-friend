class AddStateColumnToBooks < ActiveRecord::Migration[6.0]
  def change
    add_column :books, :aasm_state, :string, null: false, default: 'stocked'
  end
end
