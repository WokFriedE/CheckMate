class Item < ApplicationRecord
  # Additional methods or scopes can be added here
  DISPLAY_FIELDS = [
    :item_id, :owner_org_id, :reg_max_check, :reg_max_total_quantity,
    :reg_prebook_timeframe, :reg_borrow_time, :sup_max_checkout,
    :sup_max_total_quantity, :sup_prebook_timeframe, :sup_borrow_time,
    :created_at, :updated_at
  ]
end