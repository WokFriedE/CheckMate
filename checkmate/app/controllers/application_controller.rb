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

  def load_user_role(org_id: nil, user_id: nil)
    if user_id.nil?
      require_auth
      user_id = current_user_id
    end

    org_id ||= @organization&.org_id
    Rails.logger.info 'comparing user'
    @current_user_role = OrgRole.provide_user_role user_id, org_id
  end

  def verify_org_access?(org_id: nil, user_id: nil, expected_role: nil, user_role: nil)
    load_user_role(org_id: org_id, user_id: user_id) unless @current_user_role

    roles = expected_role.is_a?(Array) ? expected_role : [expected_role]
    effective_role = user_role || @current_user_role
    roles.include?(effective_role)
  end

  def redirect_based_on_role(path, expected_role, user_role = nil, org_id = nil)
    has_access = verify_org_access?(user_role: user_role, expected_role: expected_role, org_id: org_id)
    return if has_access

    flash.alert = 'Incorrect role, please contact an org admin'
    redirect_to path
  end

  def set_no_cache
    response.headers['Cache-Control'] = 'no-store, no-cache, must-revalidate, max-age=0'
    response.headers['Pragma'] = 'no-cache'
    response.headers['Expires'] = 'Fri, 01 Jan 1990 00:00:00 GMT'
  end

  def load_organization
    @organization = Organization.find_by(org_id: params[:organization_org_id])
    @org_id = @organization.org_id
    return if @organization

    Rails.logger.warn { "Organization not found for org_id=#{params[:organization_org_id].inspect}" }

    # For create actions, allow the caller to handle missing organization
    if action_name == 'create'
      Rails.logger.warn do
        "Organization not found for org param=#{params[:organization_org_id].inspect}; deferring handling to caller"
      end
      @organization = nil
      return
    end

    redirect_to landing_path, alert: 'Organization not found.'
    nil
  end
end
