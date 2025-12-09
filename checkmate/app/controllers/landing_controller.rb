class LandingController < ApplicationController
  before_action :require_auth
  def index
    @organizations = Organization.where(public_access: true).all
  end
end
