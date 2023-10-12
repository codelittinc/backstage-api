# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :set_user, only: %i[show update]

  def index
    @users = User.all
    # This will use app/views/users/index.json.jbuilder
  end

  def show
    # This will use app/views/users/show.json.jbuilder
  end

  def update
    if @user.update(user_params)
      render :show # This will use app/views/users/show.json.jbuilder (since it's rendering a single user)
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  private

  def set_user
    id = params['id']
    @user = id == 'me' ? current_user : User.find(id)
  end

  def user_params
    params.require(:user).permit(:active, :contract_type, :email, :first_name, :last_name, :image_url, :seniority,
                                 :google_id, :profession_id, :country)
  end
end
