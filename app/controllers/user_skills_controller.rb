# frozen_string_literal: true

class UserSkillsController < ApplicationController
  before_action :set_user_skill, only: %i[destroy]

  # GET /user_skills?user_id=:id
  def index
    @user_skills = UserSkill.where(user_id: params['user_id'])
  end

  # PATCH/PUT /user_skills
  def bulk_update
    ApplicationRecord.transaction do
      # Remove all existing skills for the user
      UserSkill.where(user_id: params.dig(:params, :user_id)).destroy_all
  
      # Permit and process the new list of user skills
      user_skills_list_params.each do |user_skill|
        new_skill = UserSkill.new(user_skill.merge(user_id: params.dig(:params, :user_id)))
        unless new_skill.save
          raise ActiveRecord::Rollback
        end
      end
    end
  
    render json: { message: 'Skills updated successfully' }, status: :ok
  end

  # DELETE /user_skills/:id
  def destroy
    @user_skill.destroy
    head :no_content
  rescue ActiveRecord::RecordNotFound
    head :not_found
  end

  # GET /user_skills/search?query=:query
  def search
    return render json: [] if params[:query].blank?
    query = params[:query].split(/[\s,]+/).map(&:downcase)
    users = UserSkill.joins(:skill).where('LOWER(skills.name) IN (?)', query).pluck(:user_id).uniq
    render json: User.where(id: users)
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user_skill
    @user_skill = UserSkill.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def user_skills_list_params
    return [] if params.dig(:params, :user_skills).blank?

    params.require(:params).require(:user_skills).map do |skill|
      skill.permit(:last_applied_in_year, :level, :years_of_experience, :skill_id)
    end
  end

  # Only allow a trusted parameter "white list" through.
  def user_skill_params
    params.require(:user_skill).permit(:last_applied_in_year, :level, :years_of_experience, :skill_id, :user_id)
  end
end
