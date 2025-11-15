# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# garbage values as place holders for inventory items

Item.delete_all


items=[
  { :item_id => 1,  :owner_org_id => 10, :reg_max_check => 3, :reg_max_total_quantity => 15, :reg_prebook_timeframe => 24, :reg_borrow_time => 72, :sup_max_checkout => 5, :sup_max_total_quantity => 20, :sup_prebook_timeframe => 12, :sup_borrow_time => 48, :created_at => "2025-01-01 10:00:00", :updated_at => "2025-01-02 12:00:00" },
  { :item_id => 2,  :owner_org_id => 11, :reg_max_check => 2, :reg_max_total_quantity => 10, :reg_prebook_timeframe => 48, :reg_borrow_time => 96, :sup_max_checkout => 4, :sup_max_total_quantity => 18, :sup_prebook_timeframe => 24, :sup_borrow_time => 72, :created_at => "2025-01-03 09:15:00", :updated_at => "2025-01-04 14:20:00" },
  { :item_id => 3,  :owner_org_id => 12, :reg_max_check => 4, :reg_max_total_quantity => 12, :reg_prebook_timeframe => 36, :reg_borrow_time => 80, :sup_max_checkout => 6, :sup_max_total_quantity => 22, :sup_prebook_timeframe => 18, :sup_borrow_time => 60, :created_at => "2025-01-05 11:30:00", :updated_at => "2025-01-06 16:10:00" },
  { :item_id => 4,  :owner_org_id => 13, :reg_max_check => 1, :reg_max_total_quantity => 8,  :reg_prebook_timeframe => 12, :reg_borrow_time => 48, :sup_max_checkout => 3, :sup_max_total_quantity => 15, :sup_prebook_timeframe => 6,  :sup_borrow_time => 36, :created_at => "2025-01-07 08:00:00", :updated_at => "2025-01-08 09:45:00" },
  { :item_id => 5,  :owner_org_id => 14, :reg_max_check => 5, :reg_max_total_quantity => 20, :reg_prebook_timeframe => 72, :reg_borrow_time => 120,:sup_max_checkout => 7, :sup_max_total_quantity => 25, :sup_prebook_timeframe => 30, :sup_borrow_time => 90, :created_at => "2025-01-09 13:10:00", :updated_at => "2025-01-10 18:25:00" },

  { :item_id => 6,  :owner_org_id => 15, :reg_max_check => 3, :reg_max_total_quantity => 14, :reg_prebook_timeframe => 20, :reg_borrow_time => 60, :sup_max_checkout => 4, :sup_max_total_quantity => 16, :sup_prebook_timeframe => 10, :sup_borrow_time => 50, :created_at => "2025-01-11 07:45:00", :updated_at => "2025-01-12 11:00:00" },
  { :item_id => 7,  :owner_org_id => 16, :reg_max_check => 2, :reg_max_total_quantity => 9,  :reg_prebook_timeframe => 30, :reg_borrow_time => 70, :sup_max_checkout => 5, :sup_max_total_quantity => 19, :sup_prebook_timeframe => 15, :sup_borrow_time => 65, :created_at => "2025-01-13 12:00:00", :updated_at => "2025-01-14 15:30:00" },
  { :item_id => 8,  :owner_org_id => 17, :reg_max_check => 4, :reg_max_total_quantity => 11, :reg_prebook_timeframe => 42, :reg_borrow_time => 78, :sup_max_checkout => 6, :sup_max_total_quantity => 21, :sup_prebook_timeframe => 20, :sup_borrow_time => 70, :created_at => "2025-01-15 09:50:00", :updated_at => "2025-01-16 12:20:00" },
  { :item_id => 9,  :owner_org_id => 18, :reg_max_check => 1, :reg_max_total_quantity => 7,  :reg_prebook_timeframe => 18, :reg_borrow_time => 40, :sup_max_checkout => 3, :sup_max_total_quantity => 13, :sup_prebook_timeframe => 8,  :sup_borrow_time => 38, :created_at => "2025-01-17 10:40:00", :updated_at => "2025-01-18 11:55:00" },
  { :item_id => 10, :owner_org_id => 19, :reg_max_check => 5, :reg_max_total_quantity => 18, :reg_prebook_timeframe => 50, :reg_borrow_time => 100,:sup_max_checkout => 7, :sup_max_total_quantity => 23, :sup_prebook_timeframe => 28, :sup_borrow_time => 88, :created_at => "2025-01-19 14:00:00", :updated_at => "2025-01-20 17:15:00" },

  { :item_id => 11, :owner_org_id => 20, :reg_max_check => 3, :reg_max_total_quantity => 16, :reg_prebook_timeframe => 26, :reg_borrow_time => 64, :sup_max_checkout => 5, :sup_max_total_quantity => 20, :sup_prebook_timeframe => 12, :sup_borrow_time => 52, :created_at => "2025-01-21 09:30:00", :updated_at => "2025-01-22 11:00:00" },
  { :item_id => 12, :owner_org_id => 21, :reg_max_check => 2, :reg_max_total_quantity => 9,  :reg_prebook_timeframe => 34, :reg_borrow_time => 72, :sup_max_checkout => 4, :sup_max_total_quantity => 17, :sup_prebook_timeframe => 14, :sup_borrow_time => 60, :created_at => "2025-01-23 13:25:00", :updated_at => "2025-01-24 16:40:00" },
  { :item_id => 13, :owner_org_id => 22, :reg_max_check => 4, :reg_max_total_quantity => 12, :reg_prebook_timeframe => 48, :reg_borrow_time => 84, :sup_max_checkout => 6, :sup_max_total_quantity => 22, :sup_prebook_timeframe => 22, :sup_borrow_time => 74, :created_at => "2025-01-25 10:10:00", :updated_at => "2025-01-26 12:30:00" },
  { :item_id => 14, :owner_org_id => 23, :reg_max_check => 1, :reg_max_total_quantity => 8,  :reg_prebook_timeframe => 15, :reg_borrow_time => 42, :sup_max_checkout => 3, :sup_max_total_quantity => 14, :sup_prebook_timeframe => 7,  :sup_borrow_time => 35, :created_at => "2025-01-27 08:55:00", :updated_at => "2025-01-28 09:45:00" },
  { :item_id => 15, :owner_org_id => 24, :reg_max_check => 5, :reg_max_total_quantity => 19, :reg_prebook_timeframe => 60, :reg_borrow_time => 110,:sup_max_checkout => 7, :sup_max_total_quantity => 24, :sup_prebook_timeframe => 30, :sup_borrow_time => 90, :created_at => "2025-01-29 12:20:00", :updated_at => "2025-01-30 15:30:00" },

  { :item_id => 16, :owner_org_id => 25, :reg_max_check => 2, :reg_max_total_quantity => 10, :reg_prebook_timeframe => 20, :reg_borrow_time => 55, :sup_max_checkout => 3, :sup_max_total_quantity => 16, :sup_prebook_timeframe => 11, :sup_borrow_time => 50, :created_at => "2025-02-01 09:10:00", :updated_at => "2025-02-02 13:25:00" },
  { :item_id => 17, :owner_org_id => 26, :reg_max_check => 3, :reg_max_total_quantity => 13, :reg_prebook_timeframe => 38, :reg_borrow_time => 78, :sup_max_checkout => 5, :sup_max_total_quantity => 19, :sup_prebook_timeframe => 16, :sup_borrow_time => 68, :created_at => "2025-02-03 08:00:00", :updated_at => "2025-02-04 14:10:00" },
  { :item_id => 18, :owner_org_id => 27, :reg_max_check => 4, :reg_max_total_quantity => 11, :reg_prebook_timeframe => 44, :reg_borrow_time => 82, :sup_max_checkout => 6, :sup_max_total_quantity => 21, :sup_prebook_timeframe => 18, :sup_borrow_time => 73, :created_at => "2025-02-05 10:20:00", :updated_at => "2025-02-06 12:40:00" },
  { :item_id => 19, :owner_org_id => 28, :reg_max_check => 1, :reg_max_total_quantity => 7,  :reg_prebook_timeframe => 22, :reg_borrow_time => 48, :sup_max_checkout => 3, :sup_max_total_quantity => 15, :sup_prebook_timeframe => 10, :sup_borrow_time => 40, :created_at => "2025-02-07 11:05:00", :updated_at => "2025-02-08 14:25:00" },
  { :item_id => 20, :owner_org_id => 29, :reg_max_check => 5, :reg_max_total_quantity => 20, :reg_prebook_timeframe => 70, :reg_borrow_time => 120,:sup_max_checkout => 8, :sup_max_total_quantity => 26, :sup_prebook_timeframe => 32, :sup_borrow_time => 100, :created_at => "2025-02-09 08:15:00", :updated_at => "2025-02-10 09:30:00" },



]



items.each do |item|
  Item.create!(item)
end



