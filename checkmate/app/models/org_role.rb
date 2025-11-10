class OrgRole < ApplicationRecord
  belongs_to :organization, foreign_key: :org_id, class_name: "Organization"
  belongs_to :user, foreign_key: :user_id, class_name: "User"

  validates :user_role, presence: true

  def self.user_role_info
    # Note: adds .user which is the auth.user table from supabase
    OrgRole.joins(:user).all
  end
end
