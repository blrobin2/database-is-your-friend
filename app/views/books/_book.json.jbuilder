json.extract! book, :id, :title, :blurb, :created_at, :updated_at
json.url book_url(book, format: :json)
