class CheersController < ApplicationController
  before_action :require_login!

  def index
    @cheers = current_user.cheers_received
    render :index
  end

  def create
    if current_user.cheers <= 0
      flash[:errors] = ["You don't have any cheers left."]
      redirect_back fallback_location: users_url
      return
    end

    @cheer = Cheer.new(
      giver_id: current_user.id,
      goal_id: params[:goal_id]
    )

    if @cheer.save
      current_user.decrement_cheer_count!
      raise 'went over cheer limit' if current_user.cheers < 0
      goal_owner_name = Goal.find(params[:goal_id]).user.username
      flash[:notices] = ["You cheered #{goal_owner_name}'s goal!"]
    else
      flash[:errors] = @cheer.errors.full_messages
    end

    redirect_back fallback_location: users_url
  end

  private
  def cheer_params
    params.require(:cheer).permit(:giver_id, :goal_id)
  end
end
