class OrgLog < ApplicationRecord
  belongs_to :user_datum,
             foreign_key: :user_id,
             primary_key: :user_id,
             optional: true # allow logs with no matching user_data

  belongs_to :organization,
             foreign_key: :org_id,
             primary_key: :org_id,
             optional: true # allow logs for deleted/nonexistent organizations

  def self.org_logs_with_user_info
    OrgLog.includes(:user_datum).all
  end

  def self.org_logs_with_org_info
    OrgLog.includes(:organization).all
  end

  def self.complete_org_logs_info
    OrgLog.includes(:user_datum, :organization).all
  end
end
