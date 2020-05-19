class AddPositionToBooks < ActiveRecord::Migration[6.0]
  def change
    add_column :books, :position, :integer
    add_index :books, :position

    execute <<~SQL
      UPDATE books
      SET position = x.row_num
      FROM (SELECT id, ROW_NUMBER() OVER(ORDER BY id) as row_num FROM books) AS x
      WHERE books.id = x.id
    SQL
  end
end
