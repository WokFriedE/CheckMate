class CreateOrgRoles < ActiveRecord::Migration[8.0]
  def change
    create_table :org_roles do |t|
      t.integer :org_id, null: false
      t.uuid :user_id, null: false
      t.string  :user_role

      t.timestamps
    end

    # Add composite unique index so (org_id, user_id) is unique
    add_index :org_roles, [:org_id, :user_id], unique: true

    # If you need a foreign key to auth.users (Postgres schema), run raw SQL:
    execute <<-SQL
      ALTER TABLE org_roles
      ADD CONSTRAINT fk_org_roles_auth_users
      FOREIGN KEY (user_id)
      REFERENCES auth.users (id)
      ON DELETE CASCADE;
    SQL
  end
end
