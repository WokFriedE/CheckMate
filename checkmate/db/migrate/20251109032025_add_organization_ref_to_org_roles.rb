class AddOrganizationRefToOrgRoles < ActiveRecord::Migration[8.0]
      def change
        add_foreign_key :org_roles, :organizations, column: :org_id
      end
end
