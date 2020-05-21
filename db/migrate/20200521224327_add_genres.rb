class AddGenres < ActiveRecord::Migration[6.0]
  def change
    create_table :genres do |t|
      t.string :name, null: false
    end

    create_table :book_genres do |t|
      t.belongs_to :book, null: false
      t.belongs_to :genre, null: false
    end

    add_foreign_key :book_genres, :genres
    add_foreign_key :book_genres, :books

    create_table :genre_groups do |t|
      t.string :genre_group_key, null: false
      t.references :genre, null: false
    end

    add_index :genre_groups, %i[genre_group_key genre_id], unique: true
    add_foreign_key :genre_groups, :genres

    add_column :sales, :genre_group_key, :string
  end
end
