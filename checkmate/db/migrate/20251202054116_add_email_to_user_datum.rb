class AddEmailToUserDatum < ActiveRecord::Migration[8.0]
  def change
    add_column :user_data, :email, :string
  end
end
