class Order < ApplicationRecord
  has_many :order_details, foreign_key: :order_id, primary_key: :order_id, dependent: :delete_all

  has_many :returns,
           foreign_key: :order_id,
           primary_key: :order_id

  belongs_to :user_datum,
             foreign_key: :user_id,
             primary_key: :user_id

  before_create :assign_unique_org_id

  HISTORY_DISPLAY_FIELDS = [
    'orders.order_id',
    'orders.order_date',
    'orders.return_status',
    'orders.order_type',
    'order_details.order_detail_id',
    'order_details.item_id',
    'order_details.due_date',
    'order_details.owner_org_id',
    'order_details.checkout_time',
    'order_details.approval_status'
  ].join(', ').freeze

  def self.orders_with_user_info
    Order.includes(:user_datum).all
  end

  def self.order_details(order_id)
    Order.includes(:returns, :user_datum, order_details: { item_detail: :item_settings }).find_by(order_id: order_id)
  end

  def self.complete_orders_info
    Order.includes(:user_datum, :order_details, :returns).all
  end

  def self.user_all_orders(user_id)
    joins(:order_details)
      .where(orders: { user_id: user_id })
      .order(order_details: :checkout_time)
      .select(HISTORY_DISPLAY_FIELDS)
  end

  def self.user_past_orders(user_id)
    joins(:order_details)
      .where(orders: { user_id: user_id })
      .where('order_details.order_date < NOW()')
      .where('orders.return_status = TRUE OR orders.return_status IS NULL')
      .order(order_details: :checkout_time)
      .select(HISTORY_DISPLAY_FIELDS)
  end

  def self.user_current_orders(user_id)
    joins(:order_details)
      .where(orders: { user_id: user_id })
      .where('orders.order_date < NOW()')
      .where(return_status: false)
      .order(order_details: :checkout_time)
      .select(HISTORY_DISPLAY_FIELDS)
  end

  def self.user_future_orders(user_id)
    joins(:order_details)
      .where(orders: { user_id: user_id })
      .where('order_details.checkout_time > ?', Time.current)
      .order(order_details: :checkout_time)
      .select(HISTORY_DISPLAY_FIELDS)
  end

  def self.org_all_orders(owner_org_id)
    joins(:order_details)
      .where(order_details: { owner_org_id: owner_org_id })
      .order(order_details: :checkout_time)
      .select(HISTORY_DISPLAY_FIELDS)
  end

  def self.org_past_orders(owner_org_id)
    joins(:order_details)
      .where(order_details: { owner_org_id: owner_org_id })
      .where('order_details.order_date < NOW()')
      .order(order_details: :checkout_time)
      .select(HISTORY_DISPLAY_FIELDS)
  end

  def self.org_current_orders(owner_org_id)
    joins(:order_details)
      .where(order_details: { owner_org_id: owner_org_id })
      .where('orders.order_date < NOW()')
      .where(return_status: false)
      .order(order_details: :checkout_time)
      .select(HISTORY_DISPLAY_FIELDS)
  end

  def self.org_future_orders(owner_org_id)
    joins(:order_details)
      .where(order_details: { owner_org_id: owner_org_id })
      .where('order_details.checkout_time > ?', Time.current)
      .order(order_details: :checkout_time)
      .select(HISTORY_DISPLAY_FIELDS)
  end

  # Convenience: derive org id from associated order details
  def owner_org_id
    order_details.first&.owner_org_id
  end

  def assign_unique_org_id
    max_retries = 10
    retries = 0
    loop do
      self.order_id = SecureRandom.random_number(1_000_000_000)
      break unless self.class.exists?(order_id: order_id)

      retries += 1
      raise "Unable to generate unique order_id after #{max_retries} attempts" if retries >= max_retries
    end
  end
end
