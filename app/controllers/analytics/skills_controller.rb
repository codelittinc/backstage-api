# frozen_string_literal: true

module Analytics
  class SkillsController < ApplicationController
    def index
      @skills = search_skills
      @report = build_report
      render json: @report
    end

    private

    def search_skills
      return Skill.all if params[:search].blank?

      Skill.where('name ILIKE ?', "%#{params[:search]}%")
    end

    def build_report
      @user_skills = UserSkill.where(skill_id: @skills.pluck(:id)).to_a
      @skills.map do |skill|
        {
          name: skill.name,
          level: UserSkill::VALID_LEVELS.map do |level|
            {
              name: level,
              count: @user_skills.select { |us| us.skill_id == skill.id && us.level == level }.count
            }
          end
        }
      end
    end
  end
end
