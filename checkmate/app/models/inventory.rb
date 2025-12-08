class Inventory < ApplicationRecord
  belongs_to :item_detail,
             foreign_key: :item_id,
             primary_key: :item_id

  belongs_to :organization,
             foreign_key: :owner_org_id,
             primary_key: :org_id

  ITEM_DISPLAY_FIELDS = [
    'item_details.item_id',
    'item_details.item_name',
    'item_details.item_comment',
    'inventories.inventory_name',
    'inventories.item_category',
    'inventories.created_at',
    'item_details.last_taken',
    'inventories.request_mode',
    'inventories.item_count'
  ].join(', ').freeze

  def self.get_detailed_inventory(org_id)
    # TODO: add pagination
    # TODO: add quantity - pass quant left
    Inventory.joins(:item_detail).where(owner_org_id: org_id).select(ITEM_DISPLAY_FIELDS)
  end

  def self.get_detailed_inventory_item(item_id)
    Inventory.joins(:item_detail).find_by(item_id: item_id)
  end

  def self.inventory_with_item_info
    Inventory.includes(:item_detail).all
  end

  def self.complete_inventory_info
    Inventory.includes(:item_detail, :organization).all
  end

  def self.organization_inventory(org_id)
    Inventory.includes(:organization).where(owner_org_id: org_id)
  end

  def self.detailed_inventory_schema
    ITEM_DISPLAY_FIELDS.split(', ').map do |attr|
      field = attr.include?('.') ? attr.split('.').last : attr
      field.titleize
    end
  end
end
