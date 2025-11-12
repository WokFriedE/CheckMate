class AddOrderForeignKeyToReturns < ActiveRecord::Migration[8.0]
  def change
    add_foreign_key :returns, :orders,
                    column: :order_id,
                    primary_key: :order_id
  end
end
