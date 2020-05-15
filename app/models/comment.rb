class Comment
  include ActiveModel::Validations

  self.abstract_class = true

  attr_accessor :body
end
