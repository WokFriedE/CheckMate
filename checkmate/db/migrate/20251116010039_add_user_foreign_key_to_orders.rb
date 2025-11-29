class AddUserForeignKeyToOrders < ActiveRecord::Migration[8.0]
  def change
    add_foreign_key :orders, :user_data,
                    column: :user_id,
                    primary_key: :user_id
  end
end
