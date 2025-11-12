class AddOrderForeignKeyToOrderDetails < ActiveRecord::Migration[8.0]
  def change
    add_foreign_key :order_details, :orders,
                    column: :order_id,
                    primary_key: :order_id
  end
end
