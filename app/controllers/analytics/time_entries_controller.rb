# frozen_string_literal: true

module Analytics
  class TimeEntriesController < ApplicationController
    before_action :set_project, only: %i[index]

    def index
      @time_entries = Analytics::TimeEntriesAnalytics.new(@project, params[:start_date],
                                                          params[:end_date]).data

      render json: @time_entries
    end

    private

    def set_project
      @project = Project.where(id: params[:project_id]).first
    end
  end
end
