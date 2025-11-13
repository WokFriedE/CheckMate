class OrderDetail < ApplicationRecord
    belongs_to :order, foreign_key: :order_id, primary_key: :order_id

    # Each order_detail belongs to one item_detail
    belongs_to :item_detail, foreign_key: :item_id, primary_key: :item_id

    belongs_to :organization,
             foreign_key: :owner_org_id,
             primary_key: :org_id
end
