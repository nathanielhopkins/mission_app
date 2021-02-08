class UsersController < ApplicationController
  before_action :require_no_login!, only: [:new, :create]
  before_action :require_login!, except: [:new, :create]
  
  def new
    @user = User.new
    render :new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      login!(@user)
      redirect_to user_url(@user)
    else
      flash.now[:errors] = @user.errors.full_messages
      render :new
    end
  end

  def index
    @users = User.all
    render :index    
  end

  def show
    @user = User.find_by(id: params[:id]) 
    
    if @user
      render :show
    else
      redirect_to users_url
    end
  end
  
  private
  def user_params
    params.require(:user).permit(:username, :password)
  end
end
