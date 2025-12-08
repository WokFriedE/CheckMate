class OrdersController < ApplicationController
  def current
    # Display current orders (not returned)
    @orders = Order.includes(:order_details, :user_datum, order_details: { item_detail: :item_settings })
                   .where(user_id: current_user_id, return_status: false)
                   .order(order_date: :desc)
  end

  def history
    # Display order history (returned orders)
    @orders = Order.includes(:order_details, :user_datum, order_details: { item_detail: :item_settings })
                   .where(user_id: current_user_id)
                   .where('return_status = ? OR return_status IS NULL', true)
                   .order(order_date: :desc)
  end

  def favorites
    # Todo later
  end
end
