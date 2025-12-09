require "test_helper"

class UserOrganizationsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get user_organizations_index_url
    assert_response :success
  end
end
