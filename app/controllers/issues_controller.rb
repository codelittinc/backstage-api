# frozen_string_literal: true

class IssuesController < ApplicationController
  before_action :set_project, only: %i[index]

  def index
    @issues = Issue.where(project: @project)

    @issues = @issues.where.not(closed_date: nil) if closed == 'true'

    @issues = @issues.where(
      '(closed_date BETWEEN :start_date AND :end_date) OR (reported_at BETWEEN :start_date AND :end_date)', start_date:, end_date:
    )
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

  def closed
    params[:closed]
  end
end
