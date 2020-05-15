class BookComment < ApplicationRecord
  include Commentable

  belongs_to :book
end