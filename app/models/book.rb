class Book < ApplicationRecord
  belongs_to :author
  has_many :comments, dependent: :destroy, as: :commentable

  validates :title, presence: true, uniqueness: true
end
