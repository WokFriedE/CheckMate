class CreateItemDetails < ActiveRecord::Migration[8.0]
  def change
    create_table :item_details do |t|
      t.integer :item_id
      t.string :item_name
      t.datetime :last_taken
      t.string :item_comment

      t.timestamps
    end
  end
end
