class AuthenticationController < ApplicationController
  # Explicitly skip the auth check for login/signup
  skip_before_action :require_auth, raise: false, only: [:signup_form, :signup, :login_form, :login]

  # GET /signup
  def signup_form
  end

  # POST /signup
  def signup
    response = SupabaseAuthService.signup(email: params[:email], password: params[:password])

    if response["error"] || response["identities"].nil? || response["identities"].empty?
      flash.now[:alert] = "A user with this email already exists."
      render :signup_form, status: :unprocessable_entity
      return
    end

    flash[:notice] = "Account created. Please confirm your email before logging in."
    redirect_to login_path
  end

  # GET /login
  def login_form
  end

  # POST /login
  def login
    response = SupabaseAuthService.login(email: params[:email], password: params[:password])

    if response["error"]
      case response["error_code"]
      when "invalid_credentials"
        flash.now[:alert] = "Incorrect password."
      when "email_not_confirmed"
        flash.now[:alert] = "Please confirm your email before logging in."
      when "user_not_found"
        flash.now[:alert] = "No user with that email found."
      else
        flash.now[:alert] = "Login failed: #{response['msg']}"
      end
      render :login_form, status: :unprocessable_entity
      return
    end

    reset_session
    session[:access_token]  = response["access_token"]
    session[:refresh_token] = response["refresh_token"]
    session[:user_email]    = response.dig("user", "email")

    redirect_to landing_path, notice: "You are logged in."
  end

  # DELETE /logout
  def logout
    reset_session
    redirect_to login_path, notice: "You have been logged out."
  end
end
