class Return < ApplicationRecord
  belongs_to :item_detail,
             foreign_key: :item_id,
             primary_key: :item_id

  belongs_to :order,
             foreign_key: :order_id,
             primary_key: :order_id

  def self.get_all_returns_with_item_info
    Return.includes(:item_detail).all
  end

  def self.get_all_returns_with_order_info
    Return.includes(:order).all
  end

  def self.get_complete_returns_info
    Return.includes(:item_detail, :order).all
  end
end
