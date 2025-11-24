class Inventory < ApplicationRecord
    belongs_to :item_detail,
             foreign_key: :item_id,
             primary_key: :item_id
             
    belongs_to :organization,
             foreign_key: :owner_org_id,
             primary_key: :org_id

    @@item_display = "item_details.item_id, item_details.item_name, item_details.item_comment, inventories.inventory_name, inventories.item_category, inventories.created_at, item_details.last_taken, inventories.request_mode, inventories.item_count"

    def self.get_detailed_inventory org_id
      # TODO: add pagination
      Inventory.joins(:item_detail).where(owner_org_id: org_id).select(@@item_display)
    end

    def self.get_detailed_inventory_item item_id
      Inventory.joins(:item_detail).where(item_id: item_id)
    end

    def self.get_detailed_inventory_schema
      @@item_display.split(", ").map do |attr|
        field = attr.include?('.') ? attr.split('.').last : attr
        field.titleize
      end
    end
end
