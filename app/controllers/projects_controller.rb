# frozen_string_literal: true

class ProjectsController < ApplicationController
  before_action :set_project, only: %i[show update destroy]

  def index
    active_only = filters_params[:active_only] == 'true'
    @projects = Project.all.order(:name)
    @projects = @projects.active_in_period(Time.zone.today, Time.zone.today) if active_only
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
                                    :logo_background_color)
  end

  def filters_params
    params.fetch(:filters, {}).permit(:active_only)
  end
end
