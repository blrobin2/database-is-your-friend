namespace :bookstore do
  desc 'Import a listing of books from books.txt'
  task import: :environment do
    File.read('books.txt').each_line do |line|
      Book.create!(title: line.chomp)
    end
  end

  def query(sql)
    report = ActiveRecord::Base.connection.execute(sql).to_a
    max_cols = report[0].size.times.map do |n|
      (
        report.map { |row| row.to_a[n][1].to_s.length } +
        [report[0].keys[n].length]
      ).max
    end
    report[0].keys.each_with_index do |header, n|
      print header.rjust(max_cols[n])
      print ' '
    end
    puts
    max_cols.each do |n|
      print '-' * n
      print ' '
    end
    puts
    report.each do |row|
      row.each_with_index do |column, n|
        print column[1].to_s.rjust(max_cols[n])
        print ' '
      end
      puts
    end
  end

  task report: :environment do
    puts 'Total book sales'
    query <<~SQL
      SELECT book_id, SUM(quantity) AS quantity
      FROM sales
      GROUP BY book_id
    SQL

    puts 'Revenue by month this year'
    query <<~SQL
      SELECT
        EXTRACT(month FROM placed_at) as month,
        SUM(unit_price * quantity) AS revenue
      FROM sales
      WHERE
        placed_at > '2020-01-1'
      GROUP BY month
      ORDER BY month
    SQL

    puts 'Sales this year by author'
    query <<~SQL
      SELECT
        author_id,
        SUM(revenue) AS revenue,
        SUM(quantity) AS quantity
      FROM sales
      WHERE
        placed_at > '2020-01-1'
      GROUP BY author_id
      ORDER BY revenue DESC
    SQL

    puts 'Sales this year by author and state'
    query <<~SQL
      SELECT
        author_id,
        state,
        SUM(revenue) AS revenue,
        SUM(quantity) AS quantity
      FROM sales
      WHERE
        placed_at > '2020-01-1'
      GROUP BY author_id, state
      ORDER BY author_id, state
    SQL
  end

  task populate_sales: :environment do
    Order.find_each do |order|
      Sale.create_from_order!(order)
    end
  end
end
