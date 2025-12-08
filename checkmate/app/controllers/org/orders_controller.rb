class Org::OrdersController < Org::BaseController
  def current
  end

  def history
  end

  def favorites
  end

  # ============= API =============

  def destroy
    load_user_role
    order_id = params[:order_id]
    order = Order.find_by!(order_id: order_id)
    Rails.logger.debug "#{order.inspect} with #{current_user_id}"
    if (@current_user_role == 'user') && (current_user_id != order.user_id)
      flash[:error] = 'You do not have permission'
      redirect_back_or_to organization_checkout_path(@organization&.org_id || params[:organization_org_id],
                                                     params[:order_id]) and return
    end

    begin
      order.destroy!
      Rails.logger.debug "deleting #{order_id} and #{order.inspect}"
      flash[:success] = 'Order Deleted'
      redirect_to landing_path and return
    rescue StandardError => e
      flash[:warning] = 'Something went wrong, please try again'
      Rails.logger.error e
      redirect_back_or_to landing_path and return
    end
  end

  def delete_item
    order_id = params[:order_id]
    item_to_delete = params[:item_id]
    item = OrderDetail.find_by(order_id: order_id, item_id: item_to_delete)
    flash[:warning] = 'Item cannot be deleted' unless item
    begin
      item.destroy
    rescue StandardError => e
      flash[:warning] = 'Something went wrong, please try again'
      Rails.logger.error e
    end
    redirect_to organization_checkout_path(organization_org_id: @org_id, order_id: order_id), notice: 'Item Removed'
  end

  def create_order(item_list = nil)
    # Assumes it comes from inventory page
    items = item_list || Array(params[:selected_items])
    if items.size == 0
      flash[:warning] = 'No items selected'
      redirect_back_or_to organization_item_details_path(organization_org_id: @org_id) and return
    end

    # Validation: ensure each selected item is a numeric ID
    raise 'invalid-format' unless items.all? { |it| it.to_s =~ /\A\d+\z/ }

    item_ids = items.map(&:to_i)
    results = ItemDetail.where(item_id: item_ids)
    raise 'all-items-do-not-exist' if results.size != item_ids.size

    # TODO: make sure there is capacity before reserving (at least 1 item)
    # TODO: also pull in current item_details / quantity
    begin
      ActiveRecord::Base.transaction do
        order_main = Order.create(user_id: current_user_id, order_date: Time.now.iso8601, return_status: false,
                                  order_type: 'pending')
        oid = order_main.order_id
        org_id = @org_id
        item_inserts = results.map do |item|
          { order_id: oid, item_id: item.item_id, owner_org_id: org_id }
        end
        OrderDetail.insert_all item_inserts
        redirect_to organization_checkout_path(organization_org_id: org_id, order_id: oid)
      end
    rescue StandardError => e
      flash[:warning] = 'Something went wrong, please try again'
      Rails.logger.error e
      redirect_back_or_to organization_item_details_path(organization_org_id: @org_id) and return
    end
  end

  def recreate_order
    order_id = params[:order_id]
    begin
      ActiveRecord::Base.transaction do
        order = Order.find_by!(order_id: order_id)
        items = order.order_details.map do |order_item|
          order_item.item_id
        end
        Rails.logger.debug items.inspect
        create_order items
      end
    rescue StandardError => e
      flash[:warning] = 'Something went wrong, please try again'
      Rails.logger.error e
    end
  end

  def confirm_order
    order_id = params[:order_id]
    return_date = params[:return_date]
    items_params = params[:items] || {}

    begin
      ActiveRecord::Base.transaction do
        order = Order.find_by!(order_id: order_id)
        order.update!(order_type: 'reserved') unless order.order_type == 'reserved'

        # Update each order_detail with quantity (count) and due_date
        items_params.each do |_index, item_data|
          item_id = item_data[:item_id]
          quantity = item_data[:quantity].to_i

          order_detail = OrderDetail.find_by(order_id: order_id, item_id: item_id)
          next unless order_detail

          order_detail.update!(
            item_count: quantity,
            due_date: return_date
          )
        end

        flash[:success] = 'Order confirmed successfully'
      end
      redirect_back(fallback_location: organization_checkout_path(@org_id, order_id)) and return
    rescue StandardError => e
      flash[:warning] = 'Something went wrong, please try again'
      Rails.logger.error e
      redirect_back(fallback_location: organization_checkout_path(@org_id, order_id)) and return
    end
  end

  def mark_returned
    order_id = params[:order_id]

    begin
      ActiveRecord::Base.transaction do
        order = Order.find_by!(order_id: order_id)
        order.update!(order_type: 'returned', return_status: true)

        flash[:success] = 'Order marked as returned'
      end
      redirect_back(fallback_location: organization_checkout_path(@org_id, order_id)) and return
    rescue StandardError => e
      flash[:warning] = 'Something went wrong, please try again'
      Rails.logger.error e
      redirect_back(fallback_location: organization_checkout_path(@org_id, order_id)) and return
    end
  end
end
