# frozen_string_literal: true

class Org::BaseController < ApplicationController
  before_action :load_organization
end
