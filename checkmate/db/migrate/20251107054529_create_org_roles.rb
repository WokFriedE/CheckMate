class CreateOrgRoles < ActiveRecord::Migration[8.0]
  def change
    create_table :org_roles do |t|
      t.integer :org_id
      t.integer :user_id
      t.string :user_role

      t.timestamps
    end
  end
end
