class Author < ApplicationRecord
  has_many :books, dependent: :delete_all
  has_many :comments, dependent: :destroy, as: :commentable
  has_one :profile
end
