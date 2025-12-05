# frozen_string_literal: true

module Org
  class BaseController < ApplicationController
    before_action :load_organization
  end
end
