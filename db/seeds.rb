# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

author = Author.create(name: 'David Foster Wallace')

author.books.create(title: 'A Supposedly Fun Thing I\'ll Never Do again', blurb: 'Collection of essays')
author.books.create(title: 'Consider the Lobster', blurb: 'Collection of essays')
author.books.create(title: 'Infinite Jest')
author.books.create(title: 'Broom in the System')

author.profile = Profile.create(
  bio: 'an award-winning American novelist, short story writer and essayist',
  birth: '1962-02-21',
  death: '2008-09-12'
)
author.save!
