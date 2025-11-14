class InventoriesController < ApplicationController
  def index
    @inventory_items = Item.all
  end
end