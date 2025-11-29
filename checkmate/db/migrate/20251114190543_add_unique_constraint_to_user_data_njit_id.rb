class AddUniqueConstraintToUserDataNjitId < ActiveRecord::Migration[8.0]
  def change
    add_index :user_data, :njit_id, unique: true
  end
end
