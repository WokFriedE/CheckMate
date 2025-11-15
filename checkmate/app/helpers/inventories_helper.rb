module InventoriesHelper
  def format_quantity(quantity)
    "#{quantity} pcs"
  end

  def inventory_item_class(item)
    item.quantity > 0 ? 'text-green-600' : 'text-red-600'
  end
end