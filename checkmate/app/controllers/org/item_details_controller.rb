module Org
  class ItemDetailsController < Org::BaseController # rubocop:disable Metrics/ClassLength
    before_action :write_access

    def write_access
      # Used to determine user org role access (admin and organizer)
      load_user_role
      @has_write_access = verify_org_access?(org_id: @organization.org_id, expected_role: %w[admin organizer])
    end

    def index
      @inventory_items = Inventory.get_detailed_inventory(params[:organization_org_id])
      @inventory_attributes = Inventory.detailed_inventory_schema
    end

    def new
      redirect_based_on_role organization_item_details_path(@org_id), %w[admin organizer]
      @inventory = Inventory.new
      @item_detail = ItemDetail.new
      @item_setting = ItemSetting.new
    end

    def destroy # rubocop:disable Metrics/CyclomaticComplexity
      redirect_based_on_role organization_item_details_path(@org_id), %w[admin organizer]
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
      org_id = @organization.org_id
      @inventory = Inventory.find_by(item_id: params[:item_id], owner_org_id: org_id)
      fetch_item_id = params[:item_id].presence || params[:id].presence
      @item_detail = ItemDetail.find_by(item_id: fetch_item_id) || ItemDetail.new(item_id: fetch_item_id)
      @item_setting = ItemSetting.find_by(item_id: fetch_item_id,
                                          owner_org_id: org_id) || ItemSetting.new(
                                            item_id: fetch_item_id, owner_org_id: org_id
                                          )
    end

    def update # rubocop:disable Metrics/CyclomaticComplexity,Metrics/PerceivedComplexity
      redirect_based_on_role organization_item_details_path(@org_id), %w[admin organizer]
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
      return if performed?

      # scope the lookup to the current organization so we don't surface items from other orgs
      org_id = @organization&.org_id
      @inventory_item = Inventory.joins(:item_detail).where(item_id: params[:item_id], owner_org_id: org_id).first

      return if @inventory_item

      Rails.logger.warn { "Inventory item not found for item_id=#{params[:item_id].inspect} org=#{org_id.inspect}" }
      redirect_to organization_item_details_path(params[:organization_org_id]), alert: 'Item not found.' and return
    end

    def create
      redirect_based_on_role organization_item_details_path(@org_id), %w[admin organizer]
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

    def check_available_quantity(item_id, org_id)
      # Get the total quantity from inventory
      inventory = Inventory.find_by(item_id: item_id, owner_org_id: org_id)
      return 0 unless inventory

      total_quantity = inventory.item_count || 0

      # Calculate quantity currently checked out (pending and reserved orders that are not returned)
      checked_out_quantity = OrderDetail
                             .joins(:order)
                             .where(item_id: item_id, owner_org_id: org_id)
                             .where(orders: { order_type: %w[pending reserved], return_status: [false, nil] })
                             .sum(:item_count)

      # Available quantity = total - checked out
      available_quantity = total_quantity - checked_out_quantity
      [available_quantity, 0].max # Ensure we don't return negative values
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
  end
end
