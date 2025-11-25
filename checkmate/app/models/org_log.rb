class OrgLog < ApplicationRecord
    belongs_to :user_datum,
             foreign_key: :user_id,
             primary_key: :user_id,
             optional: true   # allow logs with no matching user_data

    belongs_to :organization,
             foreign_key: :org_id,
             primary_key: :org_id,
             optional: true  # allow logs for deleted/nonexistent organizations
end
