class CreateUserData < ActiveRecord::Migration[8.0]
  def change
    create_table :user_data do |t|
      t.uuid :user_id
      t.string :name
      t.string :contact_num
      t.string :address
      t.string :designation
      t.bigint :njit_id
      t.boolean :returns_pending

      t.timestamps
    end
  end
end
