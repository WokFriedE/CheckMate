class Inventory < ApplicationRecord
    belongs_to :item_detail,
             foreign_key: :item_id,
             primary_key: :item_id
             
    belongs_to :organization,
             foreign_key: :owner_org_id,
             primary_key: :org_id


    def self.get_detailed_inventory org_id
      # TODO: add pagination
      Inventory.joins(:item_detail).where(owner_org_id: org_id).select('item_details.item_name, item_details.item_comment, inventories.inventory_name, inventories.item_category, inventories.created_at, item_details.last_taken, inventories.request_mode')
    end

    def self.get_detailed_inventory_schema
      return ["item_name", "item_comment", "inventory tag", "item_category", "created_at", "last_taken", "request_mode"].map { |attr| attr.titleize }
    end
end
