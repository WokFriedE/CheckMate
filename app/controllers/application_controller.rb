class ApplicationController < ActionController::Base
  helper_method :current_user
  before_action :set_no_cache   # Prevents browser from caching any page (optional global fix)

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

  def set_no_cache
    response.headers["Cache-Control"] = "no-store, no-cache, must-revalidate, max-age=0"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
  end
end
