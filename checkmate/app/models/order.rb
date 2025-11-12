class Order < ApplicationRecord
    has_many :order_details, foreign_key: :order_id, primary_key: :order_id

    has_many :returns,
           foreign_key: :order_id,
           primary_key: :order_id
end
