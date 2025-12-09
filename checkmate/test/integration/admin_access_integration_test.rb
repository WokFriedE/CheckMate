require 'test_helper'

class AdminAccessIntegrationTest < ActionDispatch::IntegrationTest
  # Admin routes require super admin authentication.
  # These tests verify route helpers generate correct paths.

  test 'admin organizations index route path generates correctly' do
    # Verify the route helper generates a valid path
    path = admin_organizations_path
    assert path.present?
    assert path.include?('admin/organizations')
  end

  test 'admin organizations new route path generates correctly' do
    path = new_admin_organization_path
    assert path.present?
    assert path.include?('admin/organizations/new')
  end

  test 'admin org roles index route path generates correctly' do
    path = admin_org_roles_path
    assert path.present?
    assert path.include?('admin/org_roles')
  end

  test 'admin org roles new route path generates correctly' do
    path = new_admin_org_role_path
    assert path.present?
    assert path.include?('admin/org_roles/new')
  end

  test 'admin organization show route path generates correctly' do
    org = Organization.create!(org_name: 'Test Org', org_location: 'Test Location')
    path = admin_organization_path(id: org.id)
    assert path.present?
    assert path.include?("admin/organizations/#{org.id}")
    Organization.destroy_all
  end

  test 'admin organization edit route path generates correctly' do
    org = Organization.create!(org_name: 'Test Org', org_location: 'Test Location')
    path = edit_admin_organization_path(id: org.id)
    assert path.present?
    assert path.include?("admin/organizations/#{org.id}/edit")
    Organization.destroy_all
  end

  test 'admin organization delete route path generates correctly' do
    org = Organization.create!(org_name: 'Test Org', org_location: 'Test Location')
    path = admin_organization_path(id: org.id)
    assert path.present?
    assert path.include?("admin/organizations/#{org.id}")
    Organization.destroy_all
  end
end
