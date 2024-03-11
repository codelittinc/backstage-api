# frozen_string_literal: true

class TimeEntriesController < ApplicationController
  before_action :set_time_entry, only: %i[show update destroy]

  def index
    @time_entries = TimeEntry.where(statement_of_work_id: filter_params[:statement_of_work_ids]).active_in_period(
      filter_params[:start_date], filter_params[:end_date]
    )
  end

  def show; end

  def create
    @time_entry = TimeEntry.new(time_entry_params)

    if @time_entry.save
      render :show, status: :created, location: @time_entry
    else
      render json: @time_entry.errors, status: :unprocessable_entity
    end
  end

  def update
    if @time_entry.update(time_entry_params)
      render :show, status: :ok, location: @time_entry
    else
      render json: @time_entry.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @time_entry.destroy
  end

  private

  def set_time_entry
    @time_entry = TimeEntry.find(params[:id])
  end

  def time_entry_params
    params.fetch(:time_entry).permit(:statement_of_work_id, :user_id, :date, :hours)
  end

  def filter_params
    params.require(:filters).permit(:start_date, :end_date, statement_of_work_ids: [])
  end
end
