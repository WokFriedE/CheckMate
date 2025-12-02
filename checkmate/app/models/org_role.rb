class OrgRole < ApplicationRecord
  belongs_to :organization, foreign_key: :org_id, primary_key: :org_id, class_name: 'Organization'
  belongs_to :user_datum, foreign_key: :user_id, primary_key: :user_id

  validates :user_role, presence: true

  def self.role_user_info
    # Use includes to eager-load associated user data to avoid N+1
    OrgRole.includes(:user_datum).all
  end

  def self.role_org_info
    OrgRole.includes(:organization).all
  end

  def self.complete_role_info
    OrgRole.includes(:user_datum, :organization).all
  end

  def self.find_by_org(org_id)
    OrgRole.where(org_id: org_id)
  end

  def self.provide_user_role(user_id, org_id)
    user_role_raw = OrgRole.where(org_id: org_id, user_id: user_id).first
    user_role_raw&.user_role
  end

  def self.destroy_by_org(org_id)
    users = find_by_org org_id
    users.each do |user|
      user.destroy!
    end
  end
end
