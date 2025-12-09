class UserOrganizationsController < ApplicationController
  def index
    uid = current_user_id
    roles = OrgRole.where(user_id: uid).all
    org_ids = roles.map { |role| role.org_id }
    @organizations = Organization.where(public_access: true).or(Organization.where(org_id: org_ids))
  end
end
