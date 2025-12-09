class OrdersController < ApplicationController
  def current
    # Display current orders (not returned)
    @orders = Order.includes(:order_details, :user_datum, order_details: { item_detail: :item_settings })
                   .where(user_id: current_user_id, order_type: 'pending')
                   .order(order_date: :desc)
  end

  def history
    # Display order history (returned orders)
    @orders = Order.includes(:order_details, :user_datum, order_details: { item_detail: :item_settings })
                   .where(user_id: current_user_id)
                   .where.not(order_type: 'pending')
                   .order(order_date: :desc)
  end

  def favorites
    # Todo later
  end
end
