class FixOrgRolesForeignKeyUseOrgId < ActiveRecord::Migration[8.0]
  def change
    # Remove existing foreign key that references organizations(id) (if present)
    remove_foreign_key :org_roles, column: :org_id if foreign_key_exists?(:org_roles, :organizations, column: :org_id)

    # Add foreign key that references organizations.org_id (primary key for orgs in app)
    add_foreign_key :org_roles, :organizations, column: :org_id, primary_key: :org_id
  end
end
