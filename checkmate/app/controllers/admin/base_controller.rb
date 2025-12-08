# frozen_string_literal: true

module Admin
  class BaseController < ApplicationController
    before_action :check_user_super

    def check_user_super
      sys_org = Organization.system_org
      has_access = verify_org_access?(org_id: sys_org.org_id, expected_role: 'admin')
      return if has_access

      flash[:warning] = 'You do not have access'
      redirect_to landing_path
    end
  end
end
