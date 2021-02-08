class GoalCommentsController < ApplicationController
  before_action :require_login!

  def create
    @comment = GoalComment.new(goal_comment_params)
    @comment.author_id = current_user.id

    if @comment.save
      flash[:notices] = ["Comment added!"]
    else
      flash[:errors] = @comment.errors.full_messages
    end

    redirect_back fallback_location: users_url
  end

  private
  def goal_comment_params
    params.require(:comment).permit(:goal_id, :body)
  end
end
