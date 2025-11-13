class Organization < ApplicationRecord
  has_many :org_roles
  has_many :users, through: :org_roles

  has_many :order_details,
           foreign_key: :owner_org_id,
           primary_key: :org_id

  has_many :inventories,
           foreign_key: :owner_org_id,
           primary_key: :org_id

  before_create :assign_unique_org_id

  def assign_unique_org_id
    loop do
      self.org_id = SecureRandom.random_number(1_000_000_000)
      break unless self.class.exists?(org_id: self.org_id)
    end
  end
end
