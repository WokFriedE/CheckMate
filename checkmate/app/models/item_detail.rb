class ItemDetail < ApplicationRecord
    has_many :order_details,
								foreign_key: :item_id,
								primary_key: :item_id

    has_many :inventories,
								foreign_key: :item_id,
								primary_key: :item_id

    has_many :item_settings,
								foreign_key: :item_id,
								primary_key: :item_id

    has_many :returns,
								foreign_key: :item_id,
								primary_key: :item_id

		before_create :assign_unique_item_id

		# Randomization prevents people from trying to iterate through orgs
		def assign_unique_item_id
			max_retries = 10
			retries = 0
			loop do
				self.item_id = SecureRandom.random_number(1_000_000_000)
				break unless self.class.exists?(item_id: self.item_id)
				retries += 1
				raise "Unable to generate unique item_id after #{max_retries} attempts" if retries >= max_retries
			end
		end
end
