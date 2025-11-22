class AddUserForeignKeyToOrgRoles < ActiveRecord::Migration[8.0]
  def change
    add_foreign_key :org_roles, :user_data,
                    column: :user_id,
                    primary_key: :user_id
  end
end
