class Order < ApplicationRecord
    has_many :order_details, foreign_key: :order_id, primary_key: :order_id
end
