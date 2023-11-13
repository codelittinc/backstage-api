# frozen_string_literal: true

module Analytics
  class FinancesController < ApplicationController
    before_action :set_project, only: %i[index]

    def index
      @finances = analytics_class.new(params[:start_date],
                                      params[:end_date], @project).data

      render json: @finances
    end

    private

    def set_project
      @project = Project.where(id: params[:project_id]).first
    end

    def analytics_class
      @project ? Analytics::ProjectFinancesAnalytics : Analytics::CompanyFinancesAnalytics
    end
  end
end
