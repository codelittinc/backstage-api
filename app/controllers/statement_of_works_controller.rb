# frozen_string_literal: true

class StatementOfWorksController < ApplicationController
  before_action :set_project
  before_action :set_statement_of_work, only: %i[show update destroy]

  def index
    @statement_of_works = @project.statement_of_works
  end

  def show; end

  def create
    @statement_of_work = @project.statement_of_works.build(statement_of_work_params)

    if @statement_of_work.save
      render :show, status: :created, location: [@project, @statement_of_work]
    else
      render json: @statement_of_work.errors, status: :unprocessable_entity
    end
  end

  def update
    if @statement_of_work.update(statement_of_work_params)
      render :show, status: :ok, location: [@project, @statement_of_work]
    else
      render json: @statement_of_work.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @statement_of_work.destroy
  end

  private

  def set_project
    @project = Project.friendly.find(params[:project_id])
  end

  def set_statement_of_work
    @statement_of_work = @project.statement_of_works.find(params[:id])
  end

  def statement_of_work_params
    params.require(:statement_of_work).permit(:model, :hourly_revenue, :total_revenue, :total_hours,
                                              :hour_delivery_schedule, :limit_by_delivery_schedule,
                                              :start_date, :end_date, :name)
  end
end
