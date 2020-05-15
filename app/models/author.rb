class Author < ApplicationRecord
  has_many :books, dependent: :delete_all
  has_many :comments, dependent: :destroy, class_name: 'AuthorComment'
  has_one :profile

  delegate :bio, :birth, :death, to: :profile
end
