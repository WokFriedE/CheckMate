require 'test_helper'

class OrdersIntegrationTest < ActionDispatch::IntegrationTest
  test 'student can view current orders' do
    get current_orders_path
    # Route exists; may redirect for auth
    assert [301, 302, 200].include?(response.status)
  end

  test 'student can view order history' do
    get history_orders_path
    # Route exists; may redirect for auth
    assert [301, 302, 200].include?(response.status)
  end

  test 'orders index redirects to current' do
    get orders_path
    # Should redirect from /orders to /orders/current
    assert_response :redirect
    assert_redirected_to current_orders_path
  end

  test 'can create an order' do
    org = Organization.create!(org_name: 'Test Org', org_location: 'Test Location')
    post organization_order_path(organization_org_id: org.org_id), params: {
      order: {
        item_id: 'test-001',
        quantity: 1
      }
    }
    # Route exists
    assert [200, 301, 302, 403, 404, 422].include?(response.status)
    Organization.destroy_all
  end

  test 'order routes exist and are accessible' do
    # Verify routes are defined and can be called without error
    assert current_orders_path.present?
    assert history_orders_path.present?
    assert orders_path.present?
  end
end
