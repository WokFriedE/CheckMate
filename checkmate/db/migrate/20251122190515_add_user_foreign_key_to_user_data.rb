class AddUserForeignKeyToUserData < ActiveRecord::Migration[8.0]
  def change
    add_foreign_key :user_data,
                    'auth.users',
                    column: :user_id,
                    primary_key: :id,
                    name: 'fk_user_data_auth_users',
                    on_delete: :cascade
  end
end
