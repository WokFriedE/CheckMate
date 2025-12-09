# app/controllers/authentication_controller.rb
#
# Controller that handles signup, login, and logout flows via Supabase.
# All API calls are performed in Ruby (via SupabaseAuthService), which
# keeps API keys hidden from the browser and ensures secure handling.

class AuthenticationController < ApplicationController # rubocop:disable Metrics/ClassLength
  # Allow unauthenticated access to signup/login pages
  skip_before_action :require_auth, raise: false, only: %i[signup_form signup login_form login]

  # Handle invalid or missing CSRF tokens gracefully
  rescue_from ActionController::InvalidAuthenticityToken, with: :handle_invalid_authenticity_token

  # Prevent browser caching so back button doesn’t show stale pages after logout
  before_action :set_no_cache

  # ============================================================
  # GET /signup
  # Simply renders the signup form.
  # ============================================================
  def signup_form
    return unless current_user

    redirect_to landing_path and return
  end

  # ============================================================
  # POST /signup
  # - Takes email and password from form
  # - Sends them to Supabase for account creation
  # - Logs request and Supabase response for debugging
  # - Displays result using flash messages
  # - Injects request + response into browser console for debugging
  # ============================================================
  def signup # rubocop:disable Metrics/PerceivedComplexity,Metrics/CyclomaticComplexity
    email    = params[:email].to_s.strip
    password = params[:password].to_s

    # Debug log: what is being sent to Supabase (do NOT log passwords)
    Rails.logger.info("[signup] forwarding to Supabase: #{{ email: email }}")

    # Call Supabase signup service
    begin
      response = SupabaseAuthService.signup(email: email, password: password)
      Rails.logger.info("[signup] Supabase raw response: #{response.inspect}")
    rescue StandardError => e
      # Network or service failure
      Rails.logger.error("[signup] provider error: #{e.class}: #{e.message}")
      flash.now[:alert] = 'Sign up failed. Please try again.'
      render :signup_form, status: :unprocessable_entity and return
    end

    # Interpret outcome (success, email already in use, invalid password, etc.)
    outcome, msg = extract_signup_outcome(response)

    # Serialize request and response for browser console
    @supabase_request_json  = { email: email, password: password }.to_json
    @supabase_response_json = response.to_json

    # Choose user-facing message based on outcome
    case outcome
    when :success
      # Create user_data entry for profile info
      begin
        supabase_user_id = response['id']

        if supabase_user_id.present?
          UserDatum.find_or_create_by!(user_id: supabase_user_id) do |user_datum|
            user_datum.email = email
          end
        end
      rescue StandardError => e
        Rails.logger.error("[signup] failed to create user_data: #{e.message}")
      end

      flash.now[:notice] = 'Account created. Please confirm your email before logging in.'
      flash.now[:notice] = 'Account created. Please confirm your email before logging in.'
      render :signup_form, status: :ok
    when :email_in_use
      flash.now[:alert] = 'This email is already in use.'
      render :signup_form, status: :unprocessable_entity
    when :invalid_password
      flash.now[:alert] = msg.presence || 'The password is not valid.'
      render :signup_form, status: :unprocessable_entity
    else
      flash.now[:alert] = msg.presence || 'Sign up failed. Please try again.'
      render :signup_form, status: :unprocessable_entity
    end
  end

  # ============================================================
  # GET /login
  # Simply renders the login form.
  # ============================================================
  def login_form
    return unless current_user

    redirect_to landing_path and return
  end

  # ============================================================
  # POST /login
  # - Sends credentials to Supabase for validation
  # - Stores returned tokens in Rails session
  # - Redirects to landing page if successful
  # - Injects response into browser console for debugging
  # ============================================================
  def login
    response = SupabaseAuthService.login(email: params[:email], password: params[:password])
    Rails.logger.info("[login] Supabase raw response: #{response.inspect}")

    # Make available to browser console
    @supabase_response_json = response.to_json

    # Interpret login outcome
    outcome, msg = extract_login_outcome(response)

    case outcome
    when :success
      reset_session
      session[:access_token]  = response['access_token']
      session[:refresh_token] = response['refresh_token']
      session[:user_email]    = response.dig('user', 'email')
      redirect_to landing_path, notice: 'You are logged in.'
    when :invalid_credentials
      flash.now[:alert] = 'Invalid credentials. Please check your email if you have an account.'
      render :login_form, status: :unprocessable_entity
    when :email_not_confirmed
      flash.now[:alert] = 'Invalid credentials. Please check your email if you have an account.'
      render :login_form, status: :unprocessable_entity
    when :user_not_found
      flash.now[:alert] = 'Invalid credentials. Please check your email if you have an account.'
      render :login_form, status: :unprocessable_entity
    else
      flash.now[:alert] = msg.presence || 'Login failed.'
      render :login_form, status: :unprocessable_entity
    end
  end

  # ============================================================
  # DELETE /logout
  # Clears session and redirects to home page.
  # ============================================================
  def logout
    require_auth
    reset_session
    redirect_to root_path, notice: 'You have been logged out.'
  end

  private

  # ============================================================
  # Analyze Supabase’s signup response and return an outcome.
  #
  # Rules:
  # 1) If response has id + timestamps:
  #      - If created_at and confirmation_sent_at are within 2 seconds → :success (new user)
  #      - Else                                                        → :email_in_use (already exists)
  # 2) If response has a message/error:
  #      - Mentions "password" → :invalid_password
  #      - Mentions "already/exists/in use" → :email_in_use
  #      - Otherwise → :unknown
  # ============================================================
  # Decides signup outcome from Supabase response without removing any
  # existing behavior. We first rely on explicit signals (error_code,
  # identities), then fall back to the original time/message heuristics.
  def extract_signup_outcome(response) # rubocop:disable Metrics/CyclomaticComplexity,Metrics/PerceivedComplexity
    return [:unknown, nil] unless response.is_a?(Hash)

    # 1) Explicit error payloads (Supabase returns code + error_code + msg)
    if response['error_code'] || response['code']
      code = response['error_code'].to_s
      msg  = response['msg'] || response.dig('error', 'message') || response['message']

      return [:email_in_use,     msg] if code == 'email_address_invalid'
      return [:invalid_password, msg] if code == 'validation_failed'
      return [:rate_limited,     msg] if code == 'over_email_send_rate_limit'
      return [:invalid_password, msg] if msg.to_s.match?(/password/i)
      return [:email_in_use,     msg] if msg.to_s.match?(/already|exists|in use|duplicate|taken/i)

      return [:unknown, msg]
    end

    if response['id']
      created_at = begin
        Time.parse(response['created_at'].to_s)
      rescue StandardError
        nil
      end
      confirmation_sent_at = begin
        Time.parse(response['confirmation_sent_at'].to_s)
      rescue StandardError
        nil
      end
      identities = response['identities'] || []

      if created_at && confirmation_sent_at
        return [:success, nil] if identities.any? && (confirmation_sent_at - created_at).abs <= 2

        # new user

        return [:email_in_use, nil] # already in DB

      end
    end

    msg = response['msg'] || response.dig('error', 'message') || response['message']
    return [:invalid_password, msg] if msg.to_s.match?(/password/i)
    return [:email_in_use,     msg] if msg.to_s.match?(/already|exists|in use|duplicate|taken/i)

    [:unknown, msg]
  end

  # ============================================================
  # Analyze Supabase’s login response and return an outcome.
  #
  # Expected error codes:
  # - "invalid_credentials" → wrong password
  # - "email_not_confirmed" → email not confirmed
  # - "user_not_found"      → no such user
  # Otherwise: unknown with raw msg
  # ============================================================
  def extract_login_outcome(response) # rubocop:disable Metrics/CyclomaticComplexity
    return [:unknown, nil] unless response.is_a?(Hash)

    if response['error'] || response['msg']
      code = response['error_code'].to_s
      msg  = response.dig('error', 'message') || response['msg']

      return [:invalid_credentials, msg] if code == 'invalid_credentials'
      return [:email_not_confirmed, msg] if code == 'email_not_confirmed'
      return [:user_not_found, msg] if code == 'user_not_found'

      return [:unknown, msg]
    end

    # If no error present, treat as success
    [:success, nil]
  end

  # ============================================================
  # Handle expired or invalid CSRF tokens without crashing.
  # ============================================================
  def handle_invalid_authenticity_token
    reset_session
    if action_name.to_s == 'signup'
      flash[:alert] = 'Account/Password is incorrect please try again.'
      redirect_to signup_path
    else
      redirect_to login_path, alert: 'Account/Password is incorrect please try again.'
    end
  end

  # ============================================================
  # Prevent browser caching (fixes back button issue after logout).
  # ============================================================
  def set_no_cache
    response.headers['Cache-Control'] = 'no-store, no-cache, must-revalidate, max-age=0'
    response.headers['Pragma'] = 'no-cache'
    response.headers['Expires'] = 'Fri, 01 Jan 1990 00:00:00 GMT'
  end
end
