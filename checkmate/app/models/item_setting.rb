class ItemSetting < ApplicationRecord
  belongs_to :item_detail,
             foreign_key: :item_id,
             primary_key: :item_id

  def self.complete_items_info
    ItemSetting.includes(:item_detail).all
  end

  def self.settings_for_item item_id
    ItemSetting.where(item_id: item_id)
  end
end
