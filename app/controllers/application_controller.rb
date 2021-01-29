class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :current_user, :logged_in?

  private
#   def login_user!(user)
#     session[:session_token] = user.reset_session_token!
#   end

  def logged_in?
    !!current_user
  end

  def current_user
    return nil unless session[:session_token]
    @current_user ||= User.find_by(session_token: session[:session_token])
  end

  def require_login!
    redirect_to new_session_url if !logged_in?
  end
end
