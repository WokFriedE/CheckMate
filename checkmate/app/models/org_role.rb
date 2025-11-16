class OrgRole < ApplicationRecord
  belongs_to :organization, foreign_key: :org_id, primary_key: :org_id, class_name: "Organization"
  belongs_to :user, foreign_key: :user_id, class_name: "User"
  belongs_to :user_datum,
             foreign_key: :user_id,
             primary_key: :user_id


  validates :user_role, presence: true

  def self.user_role_info
    # Note: adds .user which is the auth.user table from supabase
    OrgRole.joins(:user).all
  end

  def self.find_by_org org_id
    OrgRole.where(org_id: org_id)
  end

  def self.destroy_by_org org_id
    users = self.find_by_org org_id
    users.each do |user|
      user.destroy!
    end
  end
  
end
