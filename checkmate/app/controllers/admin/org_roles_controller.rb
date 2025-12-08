module Admin
  class OrgRolesController < Admin::BaseController
    def index
      org_roles = OrgRole.role_user_info
      organizations = Organization.all

      @info = {}
      organizations.each do |org|
        @info[org.org_name] = org_roles.select { |role| role[:org_id] == org.org_id }
      end
    end

    def show
      @org_role = OrgRole.find(params[:id])
    end

    def new
      @org_role = OrgRole.new
      @organizations = Organization.all
      @users = User.all
    end

    def create
      processed = org_role_params.to_h.symbolize_keys
      processed[:org_id] = processed[:org_id].to_i if processed[:org_id].present?

      # Upsert the org role
      @org_role = OrgRole.find_or_initialize_by(org_id: processed[:org_id], user_id: processed[:user_id])
      @org_role.assign_attributes(processed)

      if @org_role.save
        redirect_to admin_org_roles_path
      else
        logger.debug "OrgRole save failed: #{@org_role.errors.full_messages.join('; ')}"
        @organizations = Organization.all
        @users = User.all
        render :new, status: :unprocessable_entity
      end
    end

    private

    def org_role_params
      # Permit both `user_role` (form name) and `role` (model column) to be flexible.
      params.require(:org_role).permit(:org_id, :user_id, :user_role)
    end
  end
end
