# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :set_user, only: [:show]

  def index
    render json: User.all
  end

  def show
    render json: @user
  end

  private

  def set_user
    id = params['id']

    @user = id == 'me' ? current_user : User.find(id)
  end
end
