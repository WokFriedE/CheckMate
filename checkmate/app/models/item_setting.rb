class ItemSetting < ApplicationRecord
    belongs_to :item_detail,
             foreign_key: :item_id,
             primary_key: :item_id
end
