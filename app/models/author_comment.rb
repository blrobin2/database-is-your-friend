class AuthorComment < ApplicationRecord
  include Commentable

  belongs_to :author
end