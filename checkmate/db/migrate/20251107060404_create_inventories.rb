class CreateInventories < ActiveRecord::Migration[8.0]
  def change
    create_table :inventories do |t|
      t.integer :owner_org_id
      t.integer :item_count
      t.string :inventory_name
      t.string :item_category
      t.boolean :can_prebook
      t.boolean :lock_status
      t.string :request_mode

      t.timestamps
    end
  end
end
