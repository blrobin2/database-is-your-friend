class AddNotNullToBlurb < ActiveRecord::Migration[6.0]
  def change
    execute "UPDATE books SET blurb = '' WHERE blurb IS NULL"
    change_column :books, :blurb, :text, null: false, default: ''
  end
end
