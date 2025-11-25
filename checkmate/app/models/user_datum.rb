class UserDatum < ApplicationRecord
  self.table_name = "user_data"

  validates :user_id, presence: true
end
