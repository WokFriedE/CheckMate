class OrderDetail < ApplicationRecord
    belongs_to :order, foreign_key: :order_id, primary_key: :order_id
end
