# frozen_string_literal: true

class AssignmentsController < ApplicationController
  before_action :set_assignment, only: %i[show update destroy]

  def index
    if assignments_filter[:project_id].present?
      project = Project.find(assignments_filter[:project_id])
      statement_of_works_ids = project.statement_of_works.map(&:id)
    elsif assignments_filter[:statement_of_work_id].present?
      statement_of_works_ids = [assignments_filter[:statement_of_work_id]]
    else
      render json: { error: 'project_id or statement_of_work_id is required' }, status: :bad_request
      return
    end

    requirements = Requirement.where(statement_of_work_id: statement_of_works_ids).active_in_period(
      assignments_filter[:start_date], assignments_filter[:end_date]
    )

    @assignments = Assignment.where(requirement: requirements)
  end

  def show; end

  def create
    @assignment = Assignment.new(assignment_params)

    if @assignment.save
      render :show, status: :created, location: @assignment
    else
      render json: @assignment.errors, status: :unprocessable_entity
    end
  end

  def update
    if @assignment.update(assignment_params)
      render :show, status: :ok, location: @assignment
    else
      render json: @assignment.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @assignment.destroy
  end

  private

  def set_assignment
    @assignment = Assignment.find(params[:id])
  end

  def assignment_params
    params.require(:assignment).permit(:coverage, :requirement_id, :start_date, :end_date, :user_id)
  end

  def assignments_filter
    params.permit(:project_id, :statement_of_work_id, :start_date, :end_date)
  end
end
