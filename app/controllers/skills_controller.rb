# frozen_string_literal: true

class SkillsController < ApplicationController

  def index
    @skills = Skill.all.sort_by(&:name)
  end

  def create
    @skill = Skill.new(skill_params)

    if @skill.save
      render json: @skill, status: :created
    else
      render json: @skill.errors, status: :unprocessable_entity
    end
  end

  private


  # Only allow a trusted parameter "white list" through.
  def skill_params
    params.require(:skill).permit(:name)
  end
end
