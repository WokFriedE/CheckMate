class AddOrgForeignKeyToOrderDetails < ActiveRecord::Migration[8.0]
  def change
    add_foreign_key :order_details, :organizations,
                    column: :owner_org_id,
                    primary_key: :org_id
  end
end
