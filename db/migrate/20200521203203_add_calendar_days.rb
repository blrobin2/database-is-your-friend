class AddCalendarDays < ActiveRecord::Migration[6.0]
  def up
    create_table :calendar_days, id: false do |t|
      t.date :day, null: false
      t.integer :year, null: false
      t.integer :month, null: false
      t.integer :day_of_month, null: false
      t.integer :day_of_week, null: false
      t.integer :quarter, null: false
      t.boolean :business_day, null: false
      t.boolean :weekday, null: false
    end

    execute 'ALTER TABLE calendar_days ADD PRIMARY KEY (day)'

    add_column :sales, :placed_on, :date

    execute <<~SQL
      CREATE VIEW sales_with_days AS
        SELECT * FROM sales INNER JOIN calendar_days ON DATE(placed_at) = day
    SQL
  end

  def down
    execute <<~SQL
      DROP VIEW sales_with_days
    SQL

    remove_column :sales, :placed_on, :date
    drop_table :calendar_days
  end
end
