class GoalsController < ApplicationController
  before_action :require_login!

  def new
    @goal = Goal.new
    render :new
  end

  def create
    @goal = Goal.new(goal_params)
    @goal.user_id = current_user.id

    if @goal.save
      flash[:notices] = ["Goal saved!"]
      redirect_to goal_url(@goal)
    else
      flash.now[:errors] = @goal.errors.full_messages
      render :new
    end
  end

  def index
    @goals = current_user.goals.order(:id)
    render :index
  end

  def show
    @goal = Goal.find_by(id: params[:id])

    if @goal
      render :show
    else
      redirect_to goals_url
    end
  end

  def edit
    @goal = Goal.find_by(id: params[:id])
    redirect_to goals_url if !@goal

    if @goal.user_id == current_user.id
      render :edit
    else
      redirect_to goal_url(@goal)
    end
  end

  def update
    @goal = Goal.find_by(id: params[:id])
    redirect_to goals_url if !@goal

    if @goal.user_id == current_user.id
      if @goal.update_attributes(goal_params)
        flash[:notices] = ['Goal updated!']
        if request.referer == edit_goal_url(@goal)
          redirect_to @goal
        else
          redirect_to request.referer
        end
      else
        flash.now[:errors] = @goal.errors.full_messages
        render :edit
      end
    else
      redirect_to goal_url(@goal)
    end
  end

  def destroy
    @goal = Goal.find_by(id: params[:id])
    
    if @goal.user_id == current_user.id
      flash[:notices] = ["Goal deleted!"]
      @goal.destroy
    end
    
    redirect_to goals_url
  end

  private
  def goal_params
    params.require(:goal).permit(:title, :details, :private, :completed)
  end
end
