# frozen_string_literal: true

class UsersController < ApplicationController
  def me
    render json: current_user
  end

  def index
    render json: User.all
  end
end
