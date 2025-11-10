# Table is provided by Supabase

class User < ApplicationRecord
  self.table_name = "auth.users"
  self.primary_key = "id"

  
  has_many :org_roles, foreign_key: :user_id
  has_many :organizations, through: :org_roles

  # Other fields
  # display_name
  # email
  # phone
end
