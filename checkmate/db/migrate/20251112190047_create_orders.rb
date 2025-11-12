class CreateOrders < ActiveRecord::Migration[8.0]
  def change
    create_table :orders do |t|
      t.integer :order_id
      t.integer :user_id
      t.timestamp :order_date
      t.boolean :return_status
      t.string :order_type

      t.timestamps
    end
  end
end
