class UserDatum < ApplicationRecord
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

  def self.with_user_info user_id
    UserDatum.includes(:user).where(user_id: user_id)
  end
end
