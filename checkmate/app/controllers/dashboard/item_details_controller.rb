class Dashboard::ItemDetailsController < ApplicationController
  def index
    load_organization
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
    load_organization
    return if performed?

    begin
      fetch_item_id = params[:item_id].presence || params[:id].presence
      unless fetch_item_id
        Rails.logger.warn { "No Item id in params: #{params.inspect}" }
        redirect_back(fallback_location: organization_item_details_path(params[:organization_org_id])) 
        return
      end
      @item_detail = ItemDetail.find_by(item_id: fetch_item_id)
      unless @item_detail
        Rails.logger.warn { "ItemDetail not found for item_id=#{fetch_item_id.inspect}" }
        redirect_to organization_item_details_path(params[:organization_org_id]), alert: 'Item not found.' and return
      end

      ActiveRecord::Base.transaction do
        item_id = @item_detail.item_id
        org_id = @organization&.org_id

        ItemSetting.where(item_id: item_id, owner_org_id: org_id).find_each { |rec| rec.destroy! }
        Inventory.where(item_id: item_id, owner_org_id: org_id).find_each { |rec| rec.destroy! }

        @item_detail.destroy!
      end

      respond_to do |format|
        format.html { redirect_to organization_item_details_path(params[:organization_org_id]), notice: "Item was successfully deleted.", status: :see_other }
        format.json { head :no_content }
      end
    rescue ActiveRecord::RecordInvalid => e
      Rails.logger.error { "Unexpected ActiveRecord error: #{e.message}" }
      flash.now[:alert] = "Error with item: #{e.message}"
      redirect_back(fallback_location: root_path) 
      return 
    rescue StandardError => e
      Rails.logger.error { "Unexpected error: #{e.message}" }
      flash.now[:alert] = "Error with item: #{e.message}"
      redirect_back(fallback_location: root_path) 
      return 
    end
  end

  def edit
    load_organization
    org_id = @organization.org_id
    @inventory = Inventory.find_by(item_id: params[:item_id], owner_org_id: org_id)
    @item_detail = ItemDetail.find_by(item_id: params[:item_id])
    @item_setting = ItemSetting.find_by(item_id: params[:item_id], owner_org_id: org_id)
  end

  def update 
    load_organization
    return if performed?

    org_id = @organization&.org_id
    fetch_item_id = params[:item_id].presence || params[:id].presence
    unless fetch_item_id
      Rails.logger.warn { "No Item id in params: #{params.inspect}" }
      redirect_back(fallback_location: organization_item_details_path(params[:organization_org_id])) and return
    end

    @item_detail = ItemDetail.find_by(item_id: fetch_item_id)
    @item_setting = ItemSetting.find_by(item_id: fetch_item_id, owner_org_id: org_id)
    @inventory = Inventory.find_by(item_id: fetch_item_id, owner_org_id: org_id)

    unless @item_detail && @inventory
      Rails.logger.warn { "Inventory or ItemDetail not found for item_id=#{fetch_item_id.inspect} org=#{org_id.inspect}" }
      redirect_to organization_item_details_path(params[:organization_org_id]), alert: 'Item not found.' and return
    end

    clean_inventory = inventory_params.except(:item_detail, :item_setting)

    begin
      ActiveRecord::Base.transaction do
        @item_detail.update!(item_detail_params)

        if @item_setting
          @item_setting.update!(inventory_settings_params)
        else
          ItemSetting.create!(inventory_settings_params.merge(owner_org_id: org_id, item_id: @item_detail.item_id))
        end

        @inventory.update!(clean_inventory)
      end

      redirect_to organization_item_details_path(org_id), notice: 'Item updated.' and return
    rescue ActiveRecord::RecordInvalid => e
      Rails.logger.error { "ActiveRecord::RecordInvalid: #{e.message}" }
      flash.now[:alert] = "Error with item: #{e.record.errors.full_messages.join(', ')}"
      rebuild_form_objects
      render :edit, status: :unprocessable_entity
    rescue StandardError => e
      Rails.logger.error { "Unexpected error: #{e.message}" }
      flash.now[:alert] = "Error with item: #{e.message}"
      rebuild_form_objects
      render :edit, status: :unprocessable_entity
    end
  end

  def show
    load_organization
    return if performed?

    # scope the lookup to the current organization so we don't surface items from other orgs
    org_id = @organization&.org_id
    @inventory_item = Inventory.joins(:item_detail).where(item_id: params[:item_id], owner_org_id: org_id).first

    unless @inventory_item
      Rails.logger.warn { "Inventory item not found for item_id=#{params[:item_id].inspect} org=#{org_id.inspect}" }
      redirect_to organization_item_details_path(params[:organization_org_id]), alert: 'Item not found.' and return
    end
  end


  def create
    load_organization
    return if performed?
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
    return if @organization

    Rails.logger.debug { "Organization not found for org_id=#{params[:organization_org_id].inspect}" }
    
    if action_name == 'create'
      Rails.logger.warn { "Organization not found for org param=#{params[:organization_org_id].inspect}; deferring handling to caller" }
      @organization = nil
      return
    end

    redirect_to landing_path, alert: 'Organization not found.'
    return
  end
end
