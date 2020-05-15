class Author < ApplicationRecord
  has_many :books, dependent: :delete_all
  has_one :profile
end
