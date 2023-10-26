# frozen_string_literal: true

class StatementOfWorksController < ApplicationController
  before_action :set_statement_of_work, only: %i[show update destroy]

  # GET /statement_of_works
  # GET /statement_of_works.json
  def index
    @statement_of_works = StatementOfWork.all
  end

  # GET /statement_of_works/1
  # GET /statement_of_works/1.json
  def show; end

  # POST /statement_of_works
  # POST /statement_of_works.json
  def create
    @statement_of_work = StatementOfWork.new(statement_of_work_params)

    if @statement_of_work.save
      render :show, status: :created, location: @statement_of_work
    else
      render json: @statement_of_work.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /statement_of_works/1
  # PATCH/PUT /statement_of_works/1.json
  def update
    if @statement_of_work.update(statement_of_work_params)
      render :show, status: :ok, location: @statement_of_work
    else
      render json: @statement_of_work.errors, status: :unprocessable_entity
    end
  end

  # DELETE /statement_of_works/1
  # DELETE /statement_of_works/1.json
  def destroy
    @statement_of_work.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_statement_of_work
    @statement_of_work = StatementOfWork.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def statement_of_work_params
    params.require(:statement_of_work).permit(:model, :hourly_revenue, :total_revenue, :total_hours,
                                              :hour_delivery_schedule, :limit_by_delivery_schedule,
                                              :start_date, :end_date, :project_id)
  end
end
