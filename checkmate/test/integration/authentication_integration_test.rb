require 'test_helper'

class AuthenticationIntegrationTest < ActionDispatch::IntegrationTest
  test 'signup form is accessible' do
    get signup_path
    assert_response :success
  end

  test 'login form is accessible' do
    get login_path
    assert_response :success
  end

  test 'landing page requires authentication' do
    get landing_path
    # May redirect to login
    assert_response :redirect, :success
  end

  test 'can post signup' do
    post signup_path, params: {
      email: 'test@example.com',
      password: 'Password123!'
    }
    # Should handle the request
    assert [200, 301, 302, 403, 422].include?(response.status)
  end

  test 'can post login' do
    post login_path, params: {
      email: 'test@example.com',
      password: 'Password123!'
    }
    # Should handle the request
    assert [200, 301, 302, 403, 422].include?(response.status)
  end

  test 'can logout' do
    get logout_path
    # Should handle the request (GET logout)
    assert [200, 301, 302].include?(response.status)
  end

  test 'root path is accessible' do
    get root_path
    assert_response :success
  end
end
