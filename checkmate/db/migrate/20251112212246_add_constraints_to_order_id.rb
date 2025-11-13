class AddConstraintsToOrderId < ActiveRecord::Migration[8.0]
  def change
    # Make order_id NOT NULL
    change_column_null :orders, :order_id, false

    # Add unique index
    add_index :orders, :order_id, unique: true
  end
end
