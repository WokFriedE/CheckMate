class OrganizationMiddleware
  def initialize(app)
    @app = app
  end

  def load_organization
    @organization = Organization.find_by(org_id: params[:organization_org_id])
    @org_id = @organization.org_id
    return if @organization

    Rails.logger.debug { "Organization not found for org_id=#{params[:organization_org_id].inspect}" }

    if action_name == 'create'
      Rails.logger.warn do
        "Organization not found for org param=#{params[:organization_org_id].inspect}; deferring handling to caller"
      end
      @organization = nil
      return
    end

    redirect_to landing_path, alert: 'Organization not found.'
    nil
  end
end
