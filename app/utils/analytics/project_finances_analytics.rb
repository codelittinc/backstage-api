# frozen_string_literal: true

module Analytics
  class ProjectFinancesAnalytics
    def initialize(start_date, end_date, project)
      @start_date = start_date.to_datetime.beginning_of_day
      @end_date = end_date.to_datetime.end_of_day
      @project = project
    end

    def data
      Analytics::Finances::ProjectCalculator.new(@project, @start_date, @end_date).data
    end
  end
end
