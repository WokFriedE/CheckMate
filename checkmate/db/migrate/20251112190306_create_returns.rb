class CreateReturns < ActiveRecord::Migration[8.0]
  def change
    create_table :returns do |t|
      t.integer :order_id
      t.integer :item_id
      t.integer :return_count
      t.timestamp :return_date
      t.boolean :verify_status

      t.timestamps
    end
  end
end
