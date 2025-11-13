class Return < ApplicationRecord
    belongs_to :item_detail,
             foreign_key: :item_id,
             primary_key: :item_id

    belongs_to :order,
             foreign_key: :order_id,
             primary_key: :order_id
end
