# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

author = Author.create(name: 'David Foster Wallace')
author.profile = Profile.create(
  bio: 'an award-winning American novelist, short story writer and essayist',
  birth: '1962-02-21',
  death: '2008-09-12'
)
author.save!

author.comments.create!(body: 'Good author!')

Book.reset_column_information

book = author.books.create!(
  title: 'A Supposedly Fun Thing I\'ll Never Do again',
  blurb: 'Collection of essays'
)
book.comments.create!(body: "I've never been on a cruise ship")
book.comments.create!(body: 'One of his best')

author.books.create(
  title: 'Consider the Lobster',
  blurb: 'Collection of essays'
)
author.books.create(title: 'Infinite Jest')
author.books.create(title: 'Broom in the System')

srand 1

Buyer.create(email: 'buyer@example.com')

states = %w[CA OR WA NY TN]

100.times do |n|
  buyer = if rand > 0.5
            Buyer.all.sample
          else
            Buyer.create!(email: "buyer#{n}@example.com")
          end

  address = buyer.shipping_addresses.last ||
            buyer.shipping_addresses.create!(state: states.sample)

  books = Book.all.sort_by { rand }
  order = Order.new(
    buyer: buyer,
    placed_at: rand(300).days.ago,
    canceled_at: rand > 0.9 ? rand(10).days.ago : nil,
    shipping_address: address
  )

  rand(1..4).times do
    order.line_items.build(
      book: books.shift,
      quantity: rand(1..3),
      unit_price: rand(5..15)
    )
  end

  order.save! || (puts order.errors)
end
