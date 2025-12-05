class Dashboard::ItemDetailsController < ApplicationController
  def index
    load_organization
    @inventory_items = Inventory.get_detailed_inventory(params[:organization_org_id])
    @inventory_attributes = Inventory.detailed_inventory_schema
    Rails.logger.debug do
      "Dashboard::ItemDetailsController#index headers: #{@inventory_attributes.inspect}"
    end
  end

  def new
    # TODO: add a user role check
    @inventory = Inventory.new
    @item_detail = ItemDetail.new
    @item_setting = ItemSetting.new
  end

  def destroy
    # TODO: add a user role check
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

        ItemSetting.where(item_id: item_id, owner_org_id: org_id).destroy_all
        Inventory.where(item_id: item_id, owner_org_id: org_id).destroy_all

        @item_detail.destroy!
      end

      respond_to do |format|
        format.html do
          redirect_to organization_item_details_path(params[:organization_org_id]), notice: 'Item was successfully deleted.',
                                                                                    status: :see_other
        end
        format.json { head :no_content }
      end
    rescue ActiveRecord::RecordInvalid => e
      Rails.logger.error { "Unexpected ActiveRecord error: #{e.message}" }
      flash[:alert] = "Error with item: #{e.message}"
      redirect_back(fallback_location: root_path)
      nil
    rescue StandardError => e
      Rails.logger.error { "Unexpected error: #{e.message}" }
      flash[:alert] = "Error with item: #{e.message}"
      redirect_back(fallback_location: root_path)
      nil
    end
  end

  def edit
    # TODO: add a user role check
    load_organization
    org_id = @organization.org_id
    @inventory = Inventory.find_by(item_id: params[:item_id], owner_org_id: org_id)
    fetch_item_id = params[:item_id].presence || params[:id].presence
    @item_detail = ItemDetail.find_by(item_id: fetch_item_id) || ItemDetail.new(item_id: fetch_item_id)
    @item_setting = ItemSetting.find_by(item_id: fetch_item_id,
                                        owner_org_id: org_id) || ItemSetting.new(
                                          item_id: fetch_item_id, owner_org_id: org_id
                                        )
  end

  def update
    # TODO: add a user role check
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
      Rails.logger.warn do
        "Inventory or ItemDetail not found for item_id=#{fetch_item_id.inspect} org=#{org_id.inspect}"
      end
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
      flash[:alert] = "Error with item: #{e.message}"
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

    return if @inventory_item

    Rails.logger.warn { "Inventory item not found for item_id=#{params[:item_id].inspect} org=#{org_id.inspect}" }
    redirect_to organization_item_details_path(params[:organization_org_id]), alert: 'Item not found.' and return
  end

  def create
    # TODO: add a user role check
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
    flash[:alert] = "Error with item: #{e.message}"

    rebuild_form_objects
    render :new, status: :unprocessable_entity
  end

  def rebuild_form_objects
    @item_detail = ItemDetail.new(item_detail_params)
  rescue StandardError
    @item_detail = ItemDetail.new
    @item_setting = ItemSetting.new
  end

  def destroy # rubocop:disable Metrics/AbcSize,Metrics/CyclomaticComplexity
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
        redirect_to organization_item_details_path(params[:organization_org_id]),
                    alert: 'Item not found.' and return
      end

      ActiveRecord::Base.transaction do
        item_id = @item_detail.item_id
        org_id = @organization&.org_id

        ItemSetting.where(item_id: item_id, owner_org_id: org_id).destroy_all
        Inventory.where(item_id: item_id, owner_org_id: org_id).destroy_all

        @item_detail.destroy!
      end

      respond_to do |format|
        format.html do
          redirect_to(organization_item_details_path(params[:organization_org_id]),
                      notice: 'Item was successfully deleted.',
                      status: :see_other)
        end
        format.json { head :no_content }
      end
    rescue ActiveRecord::RecordInvalid => e
      Rails.logger.error { "Unexpected ActiveRecord error: #{e.message}" }
      flash[:alert] = "Error with item: #{e.message}"
      redirect_back(fallback_location: root_path)
      nil
    rescue StandardError => e
      Rails.logger.error { "Unexpected error: #{e.message}" }
      flash[:alert] = "Error with item: #{e.message}"
      redirect_back(fallback_location: root_path)
      nil
    end
  end

  def edit
    load_organization
    org_id = @organization.org_id
    @inventory = Inventory.find_by(item_id: params[:item_id], owner_org_id: org_id)
    fetch_item_id = params[:item_id].presence || params[:id].presence
    @item_detail = ItemDetail.find_by(item_id: fetch_item_id) || ItemDetail.new(item_id: fetch_item_id)
    @item_setting = ItemSetting.find_by(item_id: fetch_item_id,
                                        owner_org_id: org_id) || ItemSetting.new(
                                          item_id: fetch_item_id, owner_org_id: org_id
                                        )
  end

  # TODO: refactor this function
  def update # rubocop:disable Metrics/AbcSize,Metrics/CyclomaticComplexity,Metrics/PerceivedComplexity
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
      Rails.logger.warn do
        "Inventory or ItemDetail not found for item_id=#{fetch_item_id.inspect} org=#{org_id.inspect}"
      end
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
      flash[:alert] = "Error with item: #{e.message}"
      rebuild_form_objects
      render :edit, status: :unprocessable_entity
    end
  end

  def show # rubocop:disable Metrics/AbcSize
    load_organization
    return if performed?

    # scope the lookup to the current organization so we don't surface items from other orgs
    org_id = @organization&.org_id
    @inventory_item = Inventory.joins(:item_detail).where(item_id: params[:item_id], owner_org_id: org_id).first

    return if @inventory_item

    Rails.logger.warn { "Inventory item not found for item_id=#{params[:item_id].inspect} org=#{org_id.inspect}" }
    redirect_to organization_item_details_path(params[:organization_org_id]), alert: 'Item not found.' and return
  end

  def create # rubocop:disable Metrics/AbcSize
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

  def handle_transaction_error(err)
    Rails.logger.error { "ActiveRecord::RecordInvalid: #{err.message}" }
    flash.now[:alert] = "Error with item: #{err.record.errors.full_messages.join(', ')}"

    rebuild_form_objects
    render :new, status: :unprocessable_entity
  end

  def handle_unexpected_error(err)
    Rails.logger.error { "Unexpected error: #{err.message}" }
    flash[:alert] = "Error with item: #{err.message}"

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
                  item_detail: %i[item_name item_comment],
                  item_setting: %i[reg_max_check reg_max_total_quantity reg_prebook_timeframe reg_borrow_time])
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
      Rails.logger.warn do
        "Organization not found for org param=#{params[:organization_org_id].inspect}; deferring handling to caller"
      end
      @organization = nil
      return
    end

    redirect_to landing_path, alert: 'Organization not found.'
    nil
  end
end

# TODO: make it so that we have a user and a admin render --> render the page according to the role instead
# Migrate the path to just be org_inventory -> if organizer or admin, allow them to edit the pages
# when selecting items, allow it to create an order id -> order id will be used for checkout -> store in session
# When session is cleared up / user disconnects, delete the order (reclaim items)
# We also need a function to breakdown which items are still available in quantity
# Checkout screen should allow people to change the pending status of the order to confirmed or create an order with the items (for simplicity lets do that)
#   - store items wanted into session / flash to checkout or cookies
# Todo: add an action that would create an order and send them to the order page -> if they exit the order page delete it after x time
# After clicking to checkout, summon an action that would send the item ids and send it to the order creation page --> we need to do a check on quantity
