class Inventory < ApplicationRecord
    belongs_to :item_detail,
             foreign_key: :item_id,
             primary_key: :item_id
             
    belongs_to :organization,
             foreign_key: :owner_org_id,
             primary_key: :org_id

end
