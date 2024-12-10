# frozen_string_literal: true

class RequirementsController < ApplicationController
  before_action :set_requirement, only: %i[show update destroy]

  def index
    if requirements_filter[:project_id].present?
      project = Project.find(requirements_filter[:project_id])
      statement_of_works_ids = project.statement_of_works.map(&:id)
    elsif requirements_filter[:statement_of_work_id].present?
      statement_of_works_ids = [requirements_filter[:statement_of_work_id]]
    elsif requirements_filter[:assignments_ids].present?
      assignments = Assignment.where(id: requirements_filter[:assignments_ids])
      statement_of_works_ids = assignments.map(&:statement_of_work_id).uniq
    else
      render json: { error: 'project_id or statement_of_work_id is required' }, status: :bad_request
      return
    end

    @requirements = Requirement.where(statement_of_work_id: statement_of_works_ids).active_in_period(
      requirements_filter[:start_date], requirements_filter[:end_date]
    )
  end

  def show; end

  def create
    @requirement = Requirement.new(requirement_params)

    if @requirement.save
      render :show, status: :created
    else
      render json: @requirement.errors, status: :unprocessable_entity
    end
  end

  def update
    if @requirement.update(requirement_params)
      render :show, status: :ok
    else
      render json: @requirement.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @requirement.destroy
  end

  private

  def set_requirement
    @requirement = Requirement.find(params[:id])
  end

  def requirement_params
    params.require(:requirement).permit(:profession_id, :coverage, :statement_of_work_id, :start_date, :end_date)
  end

  def requirements_filter
    params.permit(:project_id, :statement_of_work_id, :start_date, :end_date, :assignments_ids)
  end
end
