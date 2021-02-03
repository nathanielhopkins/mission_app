class GoalsController < ApplicationController
  before_action :require_login!
  
  def new
    @goal = Goal.new
    render :new
  end
end
