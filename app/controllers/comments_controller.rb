class CommentsController < ApplicationController
  def create
    parent_class = [Book, Author].find { |x| params.has_key?(x.to_s.underscore) }
    return head(400) unless parent_class

    parent = parent_class.find(params[:parent_id])
    parent.comments.create!(params.require(:"#{parent_class.to_s.downcase}").permit(:body))
    redirect_back(fallback_location: authors_path)
  end
end
