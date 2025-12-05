class Order < ApplicationRecord
  has_many :order_details, foreign_key: :order_id, primary_key: :order_id

  has_many :returns,
           foreign_key: :order_id,
           primary_key: :order_id

  belongs_to :user_datum,
             foreign_key: :user_id,
             primary_key: :user_id

  def self.orders_with_user_info
    Order.includes(:user_datum).all
  end

  def self.get_order_details(order_id)
    Order.includes(:order_details).where(order_id: order_id)
  end

  def self.complete_orders_info
    Order.includes(:user_datum, :order_details, :returns).all
  end
end
