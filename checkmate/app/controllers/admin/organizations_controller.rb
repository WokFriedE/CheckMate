module Admin
  class OrganizationsController < ApplicationController
    before_action :set_organization, only: [:show, :edit, :update, :destroy]
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

    def edit
    end
  
    # PATCH/PUT /organizations/1 or /organizations/1.json
    def update
      respond_to do |format|
        if @organization.update(organization_params)
          format.html { redirect_to @organization, notice: "Organization was successfully updated.", status: :see_other }
          format.json { render :show, status: :ok, location: @organization }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @organization.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /organizations/1 or /organizations/1.json
    def destroy
      OrgRole.where(org_id: @organization.org_id).destroy_all
      @organization.destroy!
      respond_to do |format|
        format.html { redirect_to admin_organizations_path, notice: "Organization was successfully destroyed.", status: :see_other }
        format.json { head :no_content }
      end
    end

    private
    # Use callbacks to share common setup or constraints between actions.
    def set_organization
      @organization = Organization.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def organization_params
      # TODO: Adding password strength validation in the model
      # TODO: Hashing the password before storage (using has_secure_password or similar)
      params.require(:organization).permit(:org_name, :org_location, :public_access, :parent_org_id, :prebook_timeframe, :org_pwd)
    end
  end
end