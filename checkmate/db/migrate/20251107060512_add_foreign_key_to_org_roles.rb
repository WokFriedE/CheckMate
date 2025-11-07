class AddForeignKeyToOrgRoles < ActiveRecord::Migration[8.0]
  def change
    add_foreign_key :OrgUsers, :Organizations
  end
end
