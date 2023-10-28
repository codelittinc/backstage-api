# frozen_string_literal: true

class RequirementsController < ApplicationController
  before_action :set_project
  before_action :set_statement_of_work
  before_action :set_requirement, only: %i[show update destroy]

  def index
    @requirements = @statement_of_work.requirements
  end

  def show; end

  def create
    @requirement = @statement_of_work.requirements.new(requirement_params)

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

  def set_project
    @project = Project.find(params[:project_id])
  end

  def set_statement_of_work
    @statement_of_work = @project.statement_of_works.find(params[:statement_of_work_id])
  end

  def set_requirement
    @requirement = @statement_of_work.requirements.find(params[:id])
  end

  def requirement_params
    params.require(:requirement).permit(:profession_id, :coverage)
  end
end
