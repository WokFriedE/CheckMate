class CheckoutController < ApplicationController
  def show
    require_auth
    @current_order = Order.get_order_details(params[:order_id])
  end

  def update
    # Used to create or change the order history tbd
    require_auth
    current_order = Order.get_order_details(params[:order_id])
  end
end
