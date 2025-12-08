class CheckoutController < ApplicationController
  before_action :checkout_access
  # ================ VIEWS ================
  def show
    require_auth
    @order_info = Order.order_details(params[:order_id])
    @item_settings = @order_info.order_details.map do |od|
      item = od.item_detail
      item_info = if item
                    setting = item.item_settings.first
                    i_attrs = item.attributes
                    s_attrs = setting&.attributes || {}
                    s_attrs['setting_id'] = s_attrs.delete('id') if s_attrs.key?('id')
                    i_attrs.merge(s_attrs)
                  else
                    {}
                  end
      item_info[:max] = if %w[admin organizer upper].include? @current_user_role
                          item_info.fetch(:reg_max_total_quantity, 1)
                        else
                          item_info.fetch(:sup_max_total_quantity, 1)
                        end
      item_info[:min] = 1
      od.attributes.merge(item_info)
    end

    # Set this up to also allow reorders - checkout should allow reordering
    @already_ordered = @order_info.order_type != 'pending'
    @order_date = @order_info&.order_details&.first&.due_date
    # Make it so that that the due date is registered the same
  end

  # ================ SUPPORT ================

  # TODO: make a delete function for each order_items
  # TODO: Clear all to make a delete entire

  def checkout_access
    load_user_role # Used eventually for Upper vs normal user for limits and user perms
    order = Order.find_by(order_id: params[:order_id])
    unless order
      flash[:error] = 'Order is not accessible'
      redirect_to landing_path and return
    end

    higher_priv = verify_org_access?(org_id: params[:organization_org_id], user_id: current_user_id,
                                     expected_role: %w[admin organizer])
    @has_write_access = higher_priv || ((@current_user_role == 'user') && (@current_user_id != order.user_id))
    return if @has_write_access

    flash[:error] = 'Order is not accessible'
    redirect_to landing_path and return
  end
end
