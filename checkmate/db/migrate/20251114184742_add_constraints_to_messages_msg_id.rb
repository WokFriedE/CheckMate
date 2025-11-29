class AddConstraintsToMessagesMsgId < ActiveRecord::Migration[8.0]
  def change
    change_column_null :messages, :msg_id, false

    # Add a unique index on msg_id
    add_index :messages, :msg_id, unique: true
  end
end
