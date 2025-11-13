class AddConstraintsToItemId < ActiveRecord::Migration[8.0]
  def change
    # Make item_id NOT NULL
    change_column_null :item_details, :item_id, false

    # Add unique index (enforces uniqueness)
    add_index :item_details, :item_id, unique: true
  end
end
