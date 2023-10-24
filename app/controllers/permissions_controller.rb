# frozen_string_literal: true

class PermissionsController < ApplicationController
  def index
    @permissions = Permission.all
  end
end
