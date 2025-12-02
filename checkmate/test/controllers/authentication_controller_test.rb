require 'test_helper'

class AuthenticationControllerTest < ActionController::TestCase
  tests AuthenticationController

  test 'GET /login redirects to landing when already logged in' do
    session[:access_token] = 'fake-token'
    session[:user_email] = 'test@example.com'
    get :login_form
    assert_response :redirect
    assert_redirected_to landing_path
  end

  test 'GET /signup redirects to landing when already logged in' do
    session[:access_token] = 'fake-token'
    session[:user_email] = 'test@example.com'
    get :signup_form
    assert_response :redirect
    assert_redirected_to landing_path
  end
end
