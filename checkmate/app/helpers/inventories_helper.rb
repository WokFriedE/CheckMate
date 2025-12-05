module InventoriesHelper
  def format_quantity(quantity)
    "#{quantity} pcs"
  end

  def inventory_item_class(item)
    item.quantity.positive? ? 'text-green-600' : 'text-red-600'
  end
end
