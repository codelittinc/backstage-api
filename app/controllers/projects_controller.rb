# frozen_string_literal: true

class ProjectsController < ApplicationController
  before_action :set_project, only: %i[show update destroy]

  def index
    start_date = filters_params[:start_date] || Time.zone.today
    end_date = filters_params[:end_date] || Time.zone.today
    @projects = Project.active_in_period(start_date, end_date).order(:name)
  end

  def show; end

  def create
    @project = Project.new(project_params)

    if @project.save
      render :show, status: :created, location: @project
    else
      render json: @project.errors, status: :unprocessable_entity
    end
  end

  def update
    if @project.update(project_params)
      render :show, status: :ok, location: @project
    else
      render json: @project.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @project.destroy
  end

  private

  def set_project
    @project = Project.friendly.find(params[:id])
  end

  def project_params
    params.require(:project).permit(:id, :name, :customer_id, :billable, :slack_channel, :metadata, :logo_url,
                                    :logo_background_color, :sync_source_control, :sync_ticket_tracking_system)
  end

  def filters_params
    params.fetch(:filters, {}).permit(:start_date, :end_date)
  end
end
