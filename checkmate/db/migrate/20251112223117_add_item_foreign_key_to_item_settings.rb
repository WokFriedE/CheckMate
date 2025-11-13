class AddItemForeignKeyToItemSettings < ActiveRecord::Migration[8.0]
  def change
    add_foreign_key :item_settings, :item_details,
                    column: :item_id,
                    primary_key: :item_id
  end
end
