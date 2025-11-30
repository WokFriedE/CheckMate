class Inventory < ApplicationRecord
    belongs_to :item_detail,
             foreign_key: :item_id,
             primary_key: :item_id
             
    belongs_to :organization,
             foreign_key: :owner_org_id,
             primary_key: :org_id


    def self.get_detailed_inventory 
      Inventory.includes(:item_detail).all
    end

    def self.get_inventory_org_info
      Inventory.includes(:organization).all
    end

    def self.get_complete_inventory_info
      Inventory.includes(:item_detail, :organization).all
    end

    def self.get_organization_inventory org_id
      Inventory.includes(:organization).where(owner_org_id: org_id)
    end

    def self.get_detailed_inventory_schema
      return ["item_name", "item_comment", "inventory tag", "item_category", "created_at", "last_taken", "request_mode"].map { |attr| attr.titleize }
    end
end
