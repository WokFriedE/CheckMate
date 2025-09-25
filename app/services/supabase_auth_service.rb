require "httparty"
require "jwt"

class SupabaseAuthService
  include HTTParty
  base_uri ENV["SUPABASE_URL"] + "/auth/v1"

  headers "Content-Type" => "application/json"

  def self.signup(email:, password:)
    body = { email: email, password: password }.to_json
    response = post("/signup",
                    body: body,
                    headers: { "apikey" => ENV["SUPABASE_KEY"], "Content-Type" => "application/json" })
    JSON.parse(response.body)
  end

  def self.login(email:, password:)
    body = { email: email, password: password }.to_json
    response = post("/token?grant_type=password",
                    body: body,
                    headers: { "apikey" => ENV["SUPABASE_KEY"], "Content-Type" => "application/json" })
    JSON.parse(response.body)
  end

  def self.decode_jwt(token)
    begin
      JWT.decode(token, nil, false).first
    rescue
      nil
    end
  end
end
