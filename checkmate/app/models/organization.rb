class Organization < ApplicationRecord
  has_many :org_roles
  has_many :users, through: :org_roles

  has_many :order_details,
           foreign_key: :owner_org_id,
           primary_key: :org_id

  has_many :inventories,
           foreign_key: :owner_org_id,
           primary_key: :org_id
end
