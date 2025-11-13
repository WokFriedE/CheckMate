class ItemDetail < ApplicationRecord
    has_many :order_details,
           foreign_key: :item_id,
           primary_key: :item_id

    has_many :inventories,
           foreign_key: :item_id,
           primary_key: :item_id

    has_many :item_settings,
           foreign_key: :item_id,
           primary_key: :item_id

    has_many :returns,
           foreign_key: :item_id,
           primary_key: :item_id
end
