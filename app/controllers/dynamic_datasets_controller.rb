# frozen_string_literal: true

class DynamicDatasetsController < ApplicationController
  before_action :set_dynamic_dataset, only: %i[show]
  before_action :set_project, only: %i[index]

  def index
    @dynamic_datasets = @project.dynamic_datasets
  end

  private

  def set_project
    @project = Project.find(params[:project_id])
  end
end
