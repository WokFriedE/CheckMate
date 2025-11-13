module Admin
  class OrganizationsController < ApplicationController
    def index 
      @organizations = Organization.all
    end

    def show
      @organization = Organization.find(params[:id])
    end

    def new
      @organization = Organization.new
    end

    def create
      @organization = Organization.new(organization_params)
      if @organization.save
        redirect_to [:admin, @organization]
      else 
        render :new, status: :unprocessable_entity
      end
    end

    private
    def organization_params
      # TODO: Adding password strength validation in the model
      # TODO: Hashing the password before storage (using has_secure_password or similar)
      params.require(:organization).permit(:org_name, :org_location, :public_access, :parent_org_id, :prebook_timeframe, :org_pwd)
    end
  end
end