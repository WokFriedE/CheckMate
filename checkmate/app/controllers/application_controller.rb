class ApplicationController < ActionController::Base
  helper_method :current_user, :current_user_id
  before_action :set_no_cache # Prevents browser from caching any page (optional global fix)

  def current_user
    return nil unless session[:access_token]

    payload = SupabaseAuthService.decode_jwt(session[:access_token])
    id = payload && (payload['sub'] || payload['user_id'] || payload.dig('user', 'id'))

    {
      user_id: id,
      email: session[:user_email],
      token: session[:access_token]
    }
  end

  def current_user_id
    return nil unless current_user

    current_user[:user_id]
  end

  def index
    @is_logged_in = !!current_user
  end

  private

  def require_auth
    return if current_user

    flash[:alert] = 'Please log in'
    redirect_to login_path and return
  end

  def load_user_role(org_id)
    require_auth
    @user_role = OrgRole.provide_user_role current_user_id, org_id
  end

  def set_no_cache
    response.headers['Cache-Control'] = 'no-store, no-cache, must-revalidate, max-age=0'
    response.headers['Pragma'] = 'no-cache'
    response.headers['Expires'] = 'Fri, 01 Jan 1990 00:00:00 GMT'
  end
end
