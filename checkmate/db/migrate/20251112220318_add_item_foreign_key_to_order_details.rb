class AddItemForeignKeyToOrderDetails < ActiveRecord::Migration[8.0]
  def change
    add_foreign_key :order_details, :item_details,
                    column: :item_id,
                    primary_key: :item_id
  end
end
