class Dashboard::ItemDetailsController < ApplicationController
  def index
    @inventory_items = Inventory.get_detailed_inventory(params[:organization_org_id])
    @inventory_attributes = Inventory.get_detailed_inventory_schema
    Rails.logger.debug {
      "Dashboard::ItemDetailsController#index headers: #{@inventory_attributes.inspect}"
    }

  end

  def new 
    @inventory = Inventory.new
    @item_detail = ItemDetail.new
    @item_setting = ItemSetting.new
  end

  def destroy
    begin 
      @item_detail = ItemDetail.find(params[:id])
      ActiveRecord::Base.transaction do
        item_id = @item_detail.item_id
        ItemSetting.where(item_id: item_id).destroy_all!
        Inventory.where(item_id: item_id).destroy_all!
        @item_detail.destroy!
      end 
      respond_to do |format|
        format.html { redirect_to organization_item_details_path(params[:organization_org_id]), notice: "Item was successfully deleted.", status: :see_other }
        format.json { head :no_content }
      end
    rescue ActiveRecord::RecordInvalid => e
      handle_transaction_error(e)
    rescue StandardError => e
      handle_unexpected_error(e)
    end
  end

  def edit
    # TODO: to be added
  end

  def create
    load_organization
    # prefer the loaded organization so we are sure it exists
    org_id = @organization&.org_id
    unless org_id
      Rails.logger.error { "Organization not found for org_id param=#{params[:organization_org_id].inspect}" }
      flash.now[:alert] = 'Organization not found.'
      rebuild_form_objects
      return render :new, status: :unprocessable_entity
    end
    clean_inventory = inventory_params.except(:item_detail, :item_setting)

    begin
      ActiveRecord::Base.transaction do
        item_detail = ItemDetail.create!(item_detail_params)
        ItemSetting.create!(
          inventory_settings_params.merge(owner_org_id: org_id, item_id: item_detail.item_id)
        )
        @inventory = Inventory.create!(
          clean_inventory.merge(owner_org_id: org_id, item_id: item_detail.item_id)
        )
      end

      redirect_to organization_item_details_path(org_id), notice: 'Item added.' and return

    rescue ActiveRecord::RecordInvalid => e
      handle_transaction_error(e)
    rescue StandardError => e
      handle_unexpected_error(e)
    end
  end

  def handle_transaction_error(e)
    Rails.logger.error { "ActiveRecord::RecordInvalid: #{e.message}" }
    flash.now[:alert] = "Error with item: #{e.record.errors.full_messages.join(', ')}"

    rebuild_form_objects
    render :new, status: :unprocessable_entity
  end

  def handle_unexpected_error(e)
    Rails.logger.error { "Unexpected error: #{e.message}" }
    flash.now[:alert] = "Error with item: #{e.message}"

    rebuild_form_objects
    render :new, status: :unprocessable_entity
  end

  def rebuild_form_objects
    begin
      @item_detail = ItemDetail.new(item_detail_params)
    rescue StandardError
      @item_detail = ItemDetail.new
    end

    begin
      @item_setting = ItemSetting.new(inventory_settings_params)
    rescue StandardError
      @item_setting = ItemSetting.new
    end

    begin
      @inventory = Inventory.new(inventory_params)
    rescue StandardError
      @inventory = Inventory.new
    end
  end

  def item_detail_params
    params.require(:inventory)
          .require(:item_detail)
          .permit(:item_name, :item_comment)
  end

  def inventory_params
      params.require(:inventory)
        .permit(:item_category, :item_count, :can_prebook, :lock_status, :request_mode,
        item_detail: [:item_name, :item_comment],
        item_setting: [:reg_max_check, :reg_max_total_quantity, :reg_prebook_timeframe, :reg_borrow_time])
  end

  def inventory_settings_params
    params.require(:inventory)
          .require(:item_setting)
          .permit(:reg_max_check, :reg_max_total_quantity, :reg_prebook_timeframe, :reg_borrow_time)
  end

  def load_organization
    @organization = Organization.find_by(org_id: params[:organization_org_id])
    unless @organization
      redirect_to root_path, alert: 'Organization not found.'
      return
    end
  end
end
