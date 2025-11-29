# Table is provided by Supabase

class User < ApplicationRecord
  self.table_name = "auth.users"
  self.primary_key = "id"

  
  has_one :user_datum,
          foreign_key: :user_id,
          primary_key: :id,
          dependent: :destroy

  has_one :user_datum, foreign_key: :user_id

  # Other fields
  # display_name
  # email
  # phone
end
