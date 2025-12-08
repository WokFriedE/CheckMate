class Organization < ApplicationRecord
  RESERVED_ORG_NAMES = %w[system internal].freeze

  has_many :org_roles,
           foreign_key: :org_id,
           primary_key: :org_id

  has_many :users, through: :org_roles

  has_many :order_details,
           foreign_key: :owner_org_id,
           primary_key: :org_id

  has_many :inventories,
           foreign_key: :owner_org_id,
           primary_key: :org_id

  has_many :org_logs,
           foreign_key: :org_id,
           primary_key: :org_id

  before_create :assign_unique_org_id

  validate :org_name_not_reserved

  def self.system_org
    Organization.where(org_name: :system).first
  end

  def org_name_not_reserved
    return if org_name.blank?
    return unless RESERVED_ORG_NAMES.include?(org_name.to_s.downcase)

    errors.add(:org_name, "#{org_name} is reserved.")
  end

  # Randomization prevents people from trying to iterate through orgs
  def assign_unique_org_id
    max_retries = 10
    retries = 0
    loop do
      self.org_id = SecureRandom.random_number(1_000_000_000)
      break unless self.class.exists?(org_id: org_id)

      retries += 1
      raise "Unable to generate unique org_id after #{max_retries} attempts" if retries >= max_retries
    end
  end
end
