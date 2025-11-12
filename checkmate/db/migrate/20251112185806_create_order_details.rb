class CreateOrderDetails < ActiveRecord::Migration[8.0]
  def change
    create_table :order_details do |t|
      t.integer :order_id
      t.integer :item_id
      t.integer :item_count
      t.timestamp :due_date
      t.integer :owner_org_id
      t.time :checkout_time
      t.string :approval_status

      t.timestamps
    end
  end
end
