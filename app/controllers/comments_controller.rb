class CommentsController < ApplicationController
  before_action :require_login!
  
  def create
    @comment = Comment.new(comment_params)
    @comment.author_id = current_user.id

    if @comment.save
      flash[:notices] = ["Comment added!"]
    else
      flash[:errors] = @comment.errors.full_messages
    end

    redirect_back fallback_location: users_url
  end

  private
  def comment_params
    params.require(:comment).permit(:body, :commentable_id, :commentable_type)
  end
end
