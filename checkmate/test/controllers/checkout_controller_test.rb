require 'test_helper'

class CheckoutControllerTest < ActionDispatch::IntegrationTest
  test 'should redirect since dne' do
    org = Organization.find_or_create_by!(org_id: 999_999) do |o|
      o.org_name = 'Test Org'
      o.org_location = 'Test Location'
      o.public_access = true
    end

    get organization_checkout_url(organization_org_id: org.org_id, order_id: 1)
    assert_response :redirect
  end

  # TODO: add test for going to checkout page
end
