class UserCommentsController < ApplicationController
  before_action :require_login!
  
  def create
    @comment = UserComment.new(user_comment_params)
    @comment.author_id = current_user.id

    if @comment.save
      flash[:notices] = ["Comment added!"]
    else
      flash[:errors] = @comment.errors.full_messages
    end

    redirect_back fallback_location: users_url
  end

  private
  def user_comment_params
    params.require(:comment).permit(:user_id, :body)
  end
end
