class Book < ApplicationRecord
  belongs_to :author
  has_many :comments, dependent: :destroy, class_name: 'BookComment'

  validates :title, presence: true, uniqueness: true
end
