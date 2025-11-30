class AddConstraintsToUserDataUserId < ActiveRecord::Migration[8.0]
  def change
    # Ensure user_id is NOT NULL
    change_column_null :user_data, :user_id, false

    # Add a unique index to enforce uniqueness
    add_index :user_data, :user_id, unique: true
  end
end
