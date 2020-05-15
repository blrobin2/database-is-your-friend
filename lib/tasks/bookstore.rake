namespace :bookstore do
  desc 'Import a listing of books from books.txt'
  task import: :environment do
    File.read('books.txt').each_line do |line|
      Book.create!(title: line.chomp)
    end
  end
end
