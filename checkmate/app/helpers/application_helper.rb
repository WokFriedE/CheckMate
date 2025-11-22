module ApplicationHelper
  def show_navbar?
    # Hide ALL authentication views
    return false if controller_path.start_with?('authentication') || current_page?(root_path)

    # Hide ANY index action (users/index, pages/index, etc.)
    # return false if action_name == 'index'

    true
  end
end
