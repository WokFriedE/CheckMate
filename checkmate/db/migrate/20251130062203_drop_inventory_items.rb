class DropInventoryItems < ActiveRecord::Migration[8.0]
  def change
    drop_table :inventory_items
    drop_table :items
  end
end
