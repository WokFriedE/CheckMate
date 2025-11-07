class AddForeignKeyToOrgRoles < ActiveRecord::Migration[8.0]
  def change
    add_foreign_key :org_roles, :organizations, column: :org_id, primary_key: :id
  end
end
