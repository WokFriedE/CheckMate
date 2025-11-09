class CreateOrganizations < ActiveRecord::Migration[8.0]
  def change
    create_table :organizations do |t|
      t.string :org_name
      t.string :org_location
      t.integer :parent_org_id
      t.float :prebook_timeframe
      t.boolean :public_access
      t.string :org_pwd
      t.string :access_link

      t.timestamps
    end
  end
end
