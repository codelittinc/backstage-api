# frozen_string_literal: true

module Analytics
  class TimeEntriesController < ApplicationController
    before_action :set_project, only: %i[index]
    before_action :set_statement_of_work, only: %i[index]

    def index
      @time_entries = Analytics::TimeEntriesAnalytics.new(@project, @statement_of_work, params[:start_date],
                                                          params[:end_date]).data
      render json: @time_entries
    end

    private

    def set_project
      @project = Project.where(id: params[:project_id]).first
    end

    def set_statement_of_work
      @statement_of_work = StatementOfWork.where(id: params[:statement_of_work_id]).first
    end
  end
end
