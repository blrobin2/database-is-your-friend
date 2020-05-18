class AddLockVersionToBooks < ActiveRecord::Migration[6.0]
  def change
    add_column :books, :lock_version, :integer
  end
end
