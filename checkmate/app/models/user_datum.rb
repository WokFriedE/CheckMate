class UserDatum < ApplicationRecord
    self.table_name = "user_data"

       has_many :org_roles,
           foreign_key: :user_id,
           primary_key: :user_id

       has_many :orders,
           foreign_key: :user_id,
           primary_key: :user_id

       belongs_to :user,
             foreign_key: :user_id,
             primary_key: :id,
             class_name: "User"

       has_many :org_logs,
           foreign_key: :user_id,
           primary_key: :user_id

       validates :user_id, 
           presence: true
end