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
    puts
    genre = Genre.first
    puts "Revenue of #{genre.name}"
    query <<~SQL
      SELECT SUM(revenue)
      FROM sales
      INNER JOIN genre_groups gg ON gg.genre_group_key = sales.genre_group_key
      WHERE genre_id = #{genre.id}
    SQL

    puts
    puts 'Revenue by genre (IMPACT)'
    query <<~SQL
      SELECT genre_id, SUM(revenue)
      FROM sales
      INNER JOIN genre_groups gg
        ON gg.genre_group_key = sales.genre_group_key
      GROUP BY genre_id
    SQL

    puts 'Revenue by genre (Contribution)'
    query <<~SQL
      SELECT genre_id, SUM(revenue * multiplier)
      FROM sales
      INNER JOIN genre_groups gg
        ON gg.genre_group_key = sales.genre_group_key
      GROUP BY genre_id
    SQL

    puts
    puts 'Total Revenue'
    query <<~SQL
      SELECT SUM(revenue) FROM sales
    SQL

    exit
    puts 'Total book sales'
    query <<~SQL
      SELECT book_id, SUM(quantity) AS quantity
      FROM sales
      GROUP BY book_id
    SQL

    puts 'Revenue by month this year'
    query <<~SQL
      SELECT
        month,
        SUM(revenue) AS revenue
      FROM sales_with_days
      WHERE year = 2020
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

  def business_day?(d)
    return false if [0, 6].include?(d.wday) # Weekend

    matches = ->(month, day) { [month, day] == [d.month, d.day] }
    falls_on = ->(month, wday, r) {
      [month, wday] == [d.month, d.wday] && r.cover?(d.day)
    }

    return false if matches[1, 1] # New Years
    return false if matches[12, 25] # Christmas
    return false if falls_on[1, 1, 15..21] # MLK
    return false if falls_on[11, 4, 22..28] # Thanksgiving
    true
  end

  task populate_calendar_days: :environment do
    class CalendarDay < ApplicationRecord
      self.primary_key = :day
    end

    (Date.new(2019, 1, 1)..Date.new(2021, 1, 1)).each do |d|
      day = CalendarDay.new(
        year: d.year,
        month: d.month,
        day_of_month: d.day,
        day_of_week: d.wday,
        quarter: (d.month / 4) + 1,
        weekday: ![0, 6].include?(d.wday),
        business_day: business_day?(d)
      )
      day.day = d
      day.save!
    end
  end
end
