require 'test_helper'

class OrderTest < ActiveSupport::TestCase
  def setup
    @now = Time.current
  end

  test ".user_all_orders returns all order_details for a given user_id" do
    user_id = SecureRandom.uuid

    past_order = Order.create!(
      order_id: 1,
      user_id: user_id,
      order_date: @now - 3.days,
      return_status: true,
      order_type: "past"
    )
    current_order = Order.create!(
      order_id: 2,
      user_id: user_id,
      order_date: @now - 1.day,
      return_status: false,
      order_type: "current"
    )
    future_order = Order.create!(
      order_id: 3,
      user_id: user_id,
      order_date: @now + 1.day,
      return_status: false,
      order_type: "future"
    )
    other_user_order = Order.create!(
      order_id: 4,
      user_id: SecureRandom.uuid,
      order_date: @now - 2.days,
      return_status: true,
      order_type: "other"
    )

    d1 = OrderDetail.create!(order: past_order,   item_id: 10, item_count: 1)
    d2 = OrderDetail.create!(order: current_order, item_id: 11, item_count: 2)
    d3 = OrderDetail.create!(order: future_order, item_id: 12, item_count: 3)
    OrderDetail.create!(order: other_user_order, item_id: 13, item_count: 4)

    results = Order.user_all_orders(user_id)

    # Orders for this user only
    assert_equal [past_order.order_id, current_order.order_id, future_order.order_id].sort,
                 results.map(&:order_id).uniq.sort
    # All their details
    assert_equal [d1.item_id, d2.item_id, d3.item_id].sort,
                 results.map(&:item_id).sort
  end

  test ".user_past_orders returns only past orders (return_status true or nil) for user" do
    user_id = SecureRandom.uuid

    past_true = Order.create!(
      order_id: 5,
      user_id: user_id,
      order_date: @now - 3.days,
      return_status: true,
      order_type: "past"
    )
    past_nil = Order.create!(
      order_id: 6,
      user_id: user_id,
      order_date: @now - 4.days,
      return_status: nil,
      order_type: "past"
    )
    not_past = Order.create!(
      order_id: 7,
      user_id: user_id,
      order_date: @now - 2.days,
      return_status: false,
      order_type: "current"
    )

    d1 = OrderDetail.create!(order: past_true, item_id: 20, item_count: 1)
    d2 = OrderDetail.create!(order: past_nil,  item_id: 21, item_count: 1)
    OrderDetail.create!(order: not_past,       item_id: 22, item_count: 1)

    results = Order.user_past_orders(user_id)

    assert_equal [past_true.order_id, past_nil.order_id].sort,
                 results.map(&:order_id).uniq.sort
    assert_equal [d1.item_id, d2.item_id].sort,
                 results.map(&:item_id).sort
  end

  test ".user_current_orders returns only current orders (order_date < now, return_status false) for user" do
    user_id = SecureRandom.uuid

    current = Order.create!(
      order_id: 8,
      user_id: user_id,
      order_date: @now - 1.day,
      return_status: false,
      order_type: "current"
    )
    past = Order.create!(
      order_id: 9,
      user_id: user_id,
      order_date: @now - 3.days,
      return_status: true,
      order_type: "past"
    )
    future = Order.create!(
      order_id: 10,
      user_id: user_id,
      order_date: @now + 1.day,
      return_status: false,
      order_type: "future"
    )

    d_current = OrderDetail.create!(order: current, item_id: 30, item_count: 1)
    OrderDetail.create!(order: past,   item_id: 31, item_count: 1)
    OrderDetail.create!(order: future, item_id: 32, item_count: 1)

    results = Order.user_current_orders(user_id)

    assert_equal [current.order_id], results.map(&:order_id).uniq
    assert_equal [d_current.item_id], results.map(&:item_id)
  end

  test ".user_future_orders returns only future order_details (checkout_time > now) for user, sorted by checkout_time" do
    user_id = SecureRandom.uuid

    order = Order.create!(
      order_id: 11,
      user_id: user_id,
      order_date: @now,
      return_status: false,
      order_type: "future"
    )

    d_soon = OrderDetail.create!(
      order: order,
      item_id: 40,
      item_count: 1,
      checkout_time: @now + 1.hour
    )
    d_later = OrderDetail.create!(
      order: order,
      item_id: 41,
      item_count: 1,
      checkout_time: @now + 3.hours
    )
    # Not future
    OrderDetail.create!(
      order: order,
      item_id: 42,
      item_count: 1,
      checkout_time: @now - 1.hour
    )

    results = Order.user_future_orders(user_id)

    assert_equal [d_soon.item_id, d_later.item_id],
                 results.map(&:item_id)
    assert_equal [d_soon.checkout_time, d_later.checkout_time],
                 results.map(&:checkout_time)
  end

  #
  # ORG-BASED METHODS
  #

  test ".org_all_orders returns all order_details for a given owner_org_id" do
    org_id = 100

    order1 = Order.create!(
      order_id: 12,
      user_id: SecureRandom.uuid,
      order_date: @now - 1.day,
      return_status: false,
      order_type: "x"
    )
    order2 = Order.create!(
      order_id: 13,
      user_id: SecureRandom.uuid,
      order_date: @now - 2.days,
      return_status: true,
      order_type: "y"
    )

    d1 = OrderDetail.create!(order: order1, owner_org_id: org_id, item_id: 50, item_count: 1)
    d2 = OrderDetail.create!(order: order2, owner_org_id: org_id, item_id: 51, item_count: 1)
    # Different org
    OrderDetail.create!(order: order1, owner_org_id: 999, item_id: 52, item_count: 1)

    results = Order.org_all_orders(org_id)

    assert_equal [order1.order_id, order2.order_id].sort,
                 results.map(&:order_id).uniq.sort
    assert_equal [d1.item_id, d2.item_id].sort,
                 results.map(&:item_id).sort
  end

  test ".org_past_orders returns only past orders (return_status true or nil) for an org" do
    org_id = 200

    past_true = Order.create!(
      order_id: 14,
      user_id: SecureRandom.uuid,
      order_date: @now - 3.days,
      return_status: true,
      order_type: "past"
    )
    past_nil = Order.create!(
      order_id: 15,
      user_id: SecureRandom.uuid,
      order_date: @now - 4.days,
      return_status: nil,
      order_type: "past"
    )
    not_past = Order.create!(
      order_id: 16,
      user_id: SecureRandom.uuid,
      order_date: @now - 2.days,
      return_status: false,
      order_type: "current"
    )

    d1 = OrderDetail.create!(order: past_true, owner_org_id: org_id, item_id: 60, item_count: 1)
    d2 = OrderDetail.create!(order: past_nil,  owner_org_id: org_id, item_id: 61, item_count: 1)
    OrderDetail.create!(order: not_past,       owner_org_id: org_id, item_id: 62, item_count: 1)
    # Other org
    OrderDetail.create!(order: past_true, owner_org_id: 999, item_id: 63, item_count: 1)

    results = Order.org_past_orders(org_id)

    assert_equal [past_true.order_id, past_nil.order_id].sort,
                 results.map(&:order_id).uniq.sort
    assert_equal [d1.item_id, d2.item_id].sort,
                 results.map(&:item_id).sort
  end

  test ".org_current_orders returns only current orders (order_date < now, return_status false) for an org" do
    org_id = 300

    current = Order.create!(
      order_id: 17,
      user_id: SecureRandom.uuid,
      order_date: @now - 1.day,
      return_status: false,
      order_type: "current"
    )
    past = Order.create!(
      order_id: 18,
      user_id: SecureRandom.uuid,
      order_date: @now - 2.days,
      return_status: true,
      order_type: "past"
    )

    d_current = OrderDetail.create!(order: current, owner_org_id: org_id, item_id: 70, item_count: 1)
    OrderDetail.create!(order: past,    owner_org_id: org_id, item_id: 71, item_count: 1)
    # Other org
    OrderDetail.create!(order: current, owner_org_id: 999, item_id: 72, item_count: 1)

    results = Order.org_current_orders(org_id)

    assert_equal [current.order_id], results.map(&:order_id).uniq
    assert_equal [d_current.item_id], results.map(&:item_id)
  end

  test ".org_future_orders returns only future details (checkout_time > now) for an org, sorted by checkout_time" do
    org_id = 400

    order1 = Order.create!(
      order_id: 19,
      user_id: SecureRandom.uuid,
      order_date: @now,
      return_status: false,
      order_type: "future"
    )
    order2 = Order.create!(
      order_id: 20,
      user_id: SecureRandom.uuid,
      order_date: @now,
      return_status: false,
      order_type: "future"
    )

    d_earlier = OrderDetail.create!(
      order: order1,
      owner_org_id: org_id,
      item_id: 80,
      item_count: 1,
      checkout_time: @now + 1.hour
    )
    d_later = OrderDetail.create!(
      order: order2,
      owner_org_id: org_id,
      item_id: 81,
      item_count: 1,
      checkout_time: @now + 3.hours
    )
    # Different org
    OrderDetail.create!(
      order: order1,
      owner_org_id: 999,
      item_id: 82,
      item_count: 1,
      checkout_time: @now + 2.hours
    )
    # Not future
    OrderDetail.create!(
      order: order1,
      owner_org_id: org_id,
      item_id: 83,
      item_count: 1,
      checkout_time: @now - 1.hour
    )

    results = Order.org_future_orders(org_id)

    assert_equal [d_earlier.item_id, d_later.item_id],
                 results.map(&:item_id)
    assert_equal [d_earlier.checkout_time, d_later.checkout_time],
                 results.map(&:checkout_time)
  end
end
