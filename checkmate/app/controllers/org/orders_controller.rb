class Org::OrdersController < Org::BaseController
  def current
  end

  def history
  end

  def favorites
  end

  def create_order
    # Assumes it comes from inventory page
    items = Array(params[:selected_items])

    # Validation: ensure each selected item is a numeric ID
    raise 'invalid-format' unless items.all? { |it| it.to_s =~ /\A\d+\z/ }

    item_ids = items.map(&:to_i)
    results = ItemDetail.where(item_id: item_ids)
    raise 'all-items-do-not-exist' if results.size != item_ids.size

    ActiveRecord::Base.transaction do
      order_main = Order.create(user_id: current_user_id, order_date: Time.now.iso8601, return_status: false,
                                order_type: 'pending')
      oid = order_main.order_id
      org_id = @organization.org_id
      item_inserts = results.map do |item|
        { order_id: oid, item_id: item.item_id, owner_org_id: org_id }
      end
      OrderDetail.insert_all item_inserts
    end
  end
end
