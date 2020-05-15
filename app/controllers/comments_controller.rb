class CommentsController < ApplicationController
  def create
    parent_class = [Book, Author].find { |x| x.to_s == params[:parent_type] }
    return head(400) unless parent_class

    parent = parent_class.find(params[:parent_id])
    parent.comments.create!(comment_params)
    redirect_to :back
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end
end
