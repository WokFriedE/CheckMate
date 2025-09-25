class ApplicationController < ActionController::Base
  helper_method :current_user

  def current_user
    return nil unless session[:access_token]
    {
      email: session[:user_email],
      token: session[:access_token]
    }
  end

  private

  def require_auth
    unless current_user
      flash[:alert] = "Please log in"
      redirect_to login_path
    end
  end

  def index
    # Public homepage
  end
end
