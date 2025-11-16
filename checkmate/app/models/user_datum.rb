class UserDatum < ApplicationRecord
    has_many :org_roles,
           foreign_key: :user_id,
           primary_key: :user_id
end
