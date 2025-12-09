module ApplicationHelper
  include Heroicon::Engine.helpers

  def show_navbar?
    # Hide ALL authentication views
    return false if controller_path.start_with?('authentication') || current_page?(root_path)

    # Hide ANY index action (users/index, pages/index, etc.)
    # return false if action_name == 'index'

    true
  end

  def navbar_partial
    return 'shared/admin_nav_bar' if @current_user_role == 'admin'

    'shared/user_nav_bar'
  end

  def flash_to_daisy(type)
    {
      notice: 'alert-info',
      alert: 'alert-warning',
      error: 'alert-error',
      success: 'alert-success',
      warning: 'alert-warning'
    }.stringify_keys[type.to_s] || 'alert-info'
  end
end
