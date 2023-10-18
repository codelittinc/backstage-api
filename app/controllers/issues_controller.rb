# frozen_string_literal: true

class IssuesController < ApplicationController
  before_action :set_project, only: %i[index]

  def index
    @issues = Issue.where.not(closed_date: nil).where(project: @project, closed_date: start_date..end_date)
  end

  private

  def set_project
    @project = Project.find(params[:project_id])
  end

  def start_date
    params[:start_date]
  end

  def end_date
    params[:end_date]
  end
end
