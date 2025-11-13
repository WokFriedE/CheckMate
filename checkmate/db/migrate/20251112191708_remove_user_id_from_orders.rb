class RemoveUserIdFromOrders < ActiveRecord::Migration[8.0]
  def change
    remove_column :orders, :user_id, :integer
  end
end
