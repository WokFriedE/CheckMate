# app/services/supabase_auth_service.rb
#
# Service for interacting with Supabase Auth API (signup, login, decode JWT).
# Keeps secrets on the server side.

require "httparty"
require "jwt"

class SupabaseAuthService
  include HTTParty
  base_uri ENV["SUPABASE_URL"] + "/auth/v1"
  headers "Content-Type" => "application/json"

  def self.signup(email:, password:)
    body = { email: email, password: password }.to_json
    response = post(
      "/signup",
      body: body,
      headers: { "apikey" => ENV["SUPABASE_KEY"], "Content-Type" => "application/json" }
    )
    Rails.logger.info("[supabase.signup] status=#{response.code} body=#{response.body}")
    JSON.parse(response.body)
  end

  def self.login(email:, password:)
    body = { email: email, password: password }.to_json
    response = post(
      "/token?grant_type=password",
      body: body,
      headers: { "apikey" => ENV["SUPABASE_KEY"], "Content-Type" => "application/json" }
    )
    Rails.logger.info("[supabase.login] status=#{response.code} body=#{response.body}")
    JSON.parse(response.body)
  end

  def self.decode_jwt(token)
    JWT.decode(token, nil, false).first
  rescue
    nil
  end
end
