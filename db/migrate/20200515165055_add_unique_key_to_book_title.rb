class AddUniqueKeyToBookTitle < ActiveRecord::Migration[6.0]
  def change
    execute <<~SQL
      DELETE FROM books
      WHERE id IN (
        SELECT id FROM
        (
          SELECT id,
            ROW_NUMBER() OVER (PARTITION BY title ORDER BY created_at) AS row_num
          FROM books
        ) t
        WHERE t.row_num > 1
      )
    SQL
    add_index :books, :title, unique: true
  end
end
