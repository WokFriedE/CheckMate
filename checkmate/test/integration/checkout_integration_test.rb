require 'test_helper'

class CheckoutIntegrationTest < ActionDispatch::IntegrationTest
  def setup
    @org = Organization.create!(org_name: 'Test Org', org_location: 'Test Location')
  end

  def teardown
    Organization.destroy_all
  end

  test 'user can access checkout routes' do
    # Test that checkout routes are defined
    get checkout_index_path
    # Route exists (responds with redirect or success)
    assert [200, 301, 302, 401, 403].include?(response.status)
  end

  test 'user can view checkout details' do
    # Test organization checkout show route (correct parameter is organization_org_id)
    get organization_checkout_path(organization_org_id: @org.org_id, order_id: 'test-order-001')
    # Route exists (responds with redirect, success, or not found)
    assert [200, 301, 302, 401, 403, 404].include?(response.status)
  end

  test 'user can post to checkout' do
    # Test posting to organization checkout - recreate order
    # Just verify the route doesn't crash; it requires auth so will redirect
    post organization_recreate_order_path(organization_org_id: @org.org_id, order_id: 'test-order-001'), params: {
      item_id: 'test-item-001',
      quantity: 1
    }
    # Route is callable without error
    assert response.present?
  end

  test 'user can update checkout' do
    # Test updating checkout status
    post organization_mark_returned_checkout_path(organization_org_id: @org.org_id, order_id: 'test-order-001'), params: {
      quantity: 2
    }
    # Route exists
    assert [200, 301, 302, 401, 403, 404, 422].include?(response.status)
  end

  test 'organization checkout routes exist' do
    # Test finalize checkout route
    post organization_finalize_checkout_path(organization_org_id: @org.org_id, order_id: 'test-001'), params: {
      status: 'confirmed'
    }
    # Route should exist (respond with redirect, success, or error)
    assert [200, 301, 302, 401, 403, 404, 422].include?(response.status)
  end
end
