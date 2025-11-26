class RemoveAuthUsersFkFromOrgRoles < ActiveRecord::Migration[8.0]
  def change
    remove_foreign_key :org_roles, name: "fk_org_roles_auth_users"
  end
end
