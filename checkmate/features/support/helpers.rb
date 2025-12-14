# frozen_string_literal: true

# Helper methods for Cucumber tests
module CucumberHelpers
  # Simulate login by setting session variables directly
  # This bypasses Supabase authentication for testing purposes
  def login_as_test_user(user_datum, role: nil, org: nil)
    # Store user info in instance variables for access in steps
    @current_test_user = user_datum
    @current_test_org = org
    @current_test_role = role

    # Set session via Rack::Test
    page.set_rack_session(
      access_token: generate_mock_jwt(user_datum.user_id),
      user_email: user_datum.email,
      refresh_token: 'mock_refresh_token'
    )
  end

  def generate_mock_jwt(user_id)
    # Create a properly formatted mock JWT for testing
    # JWT format: header.payload.signature (all base64 encoded)
    header = { 'alg' => 'none', 'typ' => 'JWT' }
    payload = {
      'sub' => user_id,
      'user_id' => user_id,
      'exp' => 1.hour.from_now.to_i,
      'iat' => Time.now.to_i
    }

    # Base64 encode without padding (standard JWT format)
    header_b64 = Base64.urlsafe_encode64(header.to_json, padding: false)
    payload_b64 = Base64.urlsafe_encode64(payload.to_json, padding: false)

    # Return properly formatted JWT (no signature needed since decode uses verify: false)
    "#{header_b64}.#{payload_b64}."
  end

  # Create a test user with associated user_datum
  # FK constraint to auth.users is dropped in env.rb Before hook
  def create_test_user(email: 'test@example.com', name: 'Test User')
    user_id = SecureRandom.uuid

    user_datum = UserDatum.new(
      user_id: user_id,
      email: email,
      name: name
    )
    user_datum.save!(validate: false)
    user_datum
  end

  # Create a test organization
  def create_test_organization(name: 'Test Organization', location: 'Test Location')
    Organization.create!(
      org_name: name,
      org_location: location
    )
  end

  # Assign a role to a user in an organization
  # FK constraints are dropped in env.rb Before hook
  def assign_role(user_datum:, organization:, role:)
    OrgRole.create!(
      user_id: user_datum.user_id,
      org_id: organization.org_id,
      user_role: role
    )
  end

  # Create a test item in the inventory
  def create_test_item(organization:, name:, count: 10, category: 'General')
    item_detail = ItemDetail.create!(
      item_name: name,
      item_comment: "Test item: #{name}"
    )

    Inventory.create!(
      owner_org_id: organization.org_id,
      item_id: item_detail.item_id,
      inventory_name: name,
      item_count: count,
      item_category: category,
      can_prebook: true,
      lock_status: false,
      request_mode: 'self-checkout'
    )

    ItemSetting.create!(
      item_id: item_detail.item_id,
      owner_org_id: organization.org_id,
      reg_max_check: 5,
      reg_max_total_quantity: 10,
      reg_prebook_timeframe: 7,
      reg_borrow_time: 14
    )

    item_detail
  end

  # Map page names to paths
  def path_for(page_name)
    case page_name.downcase
    when 'home', 'root'
      '/'
    when 'login'
      login_path
    when 'signup', 'sign up'
      signup_path
    when 'landing'
      landing_path
    when 'inventory', 'inventory dashboard'
      raise 'Organization required for inventory path' unless @current_test_org

      organization_item_details_path(@current_test_org.org_id)
    when 'new item', 'add item'
      raise 'Organization required for new item path' unless @current_test_org

      new_organization_item_detail_path(@current_test_org.org_id)
    when 'admin organizations'
      admin_organizations_path
    when 'admin org roles'
      admin_org_roles_path
    else
      raise "Unknown page: #{page_name}"
    end
  end
end

World(CucumberHelpers)
