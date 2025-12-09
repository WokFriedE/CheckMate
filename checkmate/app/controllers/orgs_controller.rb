# org controller for user views
class UserOrganizationsController < ApplicationController
  def index
    @organizations = Organization.all
    render 'landing/index'
  end
end
