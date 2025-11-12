class AddItemForeignKeyToInventories < ActiveRecord::Migration[8.0]
  def change
    add_foreign_key :inventories, :item_details,
                    column: :item_id,
                    primary_key: :item_id
  end
end
