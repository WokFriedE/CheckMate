class CreateItemSettings < ActiveRecord::Migration[8.0]
  def change
    create_table :item_settings do |t|
      t.integer :item_id
      t.integer :owner_org_id
      t.integer :reg_max_check
      t.integer :reg_max_total_quantity
      t.integer :reg_prebook_timeframe
      t.integer :reg_borrow_time
      t.integer :sup_max_checkout
      t.integer :sup_max_total_quantity
      t.integer :sup_prebook_timeframe
      t.integer :sup_borrow_time

      t.timestamps
    end
  end
end
