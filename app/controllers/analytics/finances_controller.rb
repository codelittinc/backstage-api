# frozen_string_literal: true

module Analytics
  class FinancesController < ApplicationController
    before_action :set_project, only: %i[index]

    def index
      @finances = if @project
                    Analytics::Finances::Models::FinancialStatementsOfWork.new(@project, start_date, end_date)
                  else
                    Analytics::Finances::Models::FinancialProjects.new(start_date, end_date)
                  end
    end

    private

    def set_project
      @project = Project.where(id: params[:project_id]).first
    end

    def start_date
      params[:start_date].to_datetime.beginning_of_day
    end

    def end_date
      params[:end_date].to_datetime.end_of_day
    end
  end
end
