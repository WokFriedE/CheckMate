class AddUniqueIndexToOrganizationsOrgId < ActiveRecord::Migration[8.0]
  def change
    # Make sure org_id cannot be NULL (required for FK target)
    change_column_null :organizations, :org_id, false

    # Add a unique index so it can be referenced by a foreign key
    add_index :organizations, :org_id, unique: true
  end
end
