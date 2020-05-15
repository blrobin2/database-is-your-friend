class AddAuthorToBooks < ActiveRecord::Migration[6.0]
  def change
    # Belongs to creates index, foreign_key creates association
    add_belongs_to :books, :author
    add_foreign_key :books, :authors, on_delete: :restrict
  end
end
