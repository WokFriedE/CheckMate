class Organization < ApplicationRecord
  has_many :org_roles
  has_many :users, through: :org_roles
end
