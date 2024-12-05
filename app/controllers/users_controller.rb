# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :set_user, only: %i[show update]

  def index
    query = params['query']&.split(',')
    skills_filter = params['filter_by_skills']&.split(/[\s,]+/)&.map(&:downcase)

    @users = if query
               User.by_external_identifier(query)
             else
               User.all
             end

    if skills_filter.present?
      @users = @users.joins(:skills).where('LOWER(skills.name) LIKE ANY (ARRAY[?])', skills_filter.map { |s| "%#{s}%" })
    end
    @users = @users.order(:first_name, :last_name)
  end

  def show
    # This will use app/views/users/show.json.jbuilder
  end

  def create
    @user = User.new(user_params)

    if @user.save
      render :show, status: :created, location: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def update
    ApplicationRecord.transaction do
      @user.salaries.destroy_all

      raise ActiveRecord::Rollback unless @user.update(user_params)
    end

    if @user.update(user_params)
      render :show # This will use app/views/users/show.json.jbuilder (since it's rendering a single user)
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  private

  def set_user
    id = params['id']
    @user = id == 'me' ? current_user : User.friendly.find(id)
  end

  def user_params
    params.require(:user).permit(:active, :internal, :contract_type, :email, :first_name, :last_name, :image_url,
                                 :seniority, :google_id, :profession_id, :country,
                                 user_service_identifiers_attributes: %i[id identifier service_name customer_id],
                                 salaries_attributes: %i[yearly_salary start_date])
  end
end
