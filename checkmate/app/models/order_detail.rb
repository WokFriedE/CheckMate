class OrderDetail < ApplicationRecord
    belongs_to :order, foreign_key: :order_id, primary_key: :order_id

    # Each order_detail belongs to one item_detail
    belongs_to :item_detail, foreign_key: :item_id, primary_key: :item_id

    belongs_to :organization,
             foreign_key: :owner_org_id,
             primary_key: :org_id

    def self.get_order_details_with_item_info order_id
      OrderDetail.includes(:item_detail).where(order_id: order_id)
    end
    
    def self.complete_order_details_info
      OrderDetail.includes(:item_detail, :organization, :order).all
    end

    def self.order_full_details
      OrderDetail.includes(:order).all
    end
end
