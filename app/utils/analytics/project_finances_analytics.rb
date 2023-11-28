# frozen_string_literal: true

module Analytics
  class ProjectFinancesAnalytics
    def initialize(start_date, end_date, statement_of_work)
      @start_date = start_date.to_datetime.beginning_of_day
      @end_date = end_date.to_datetime.end_of_day
      @statement_of_work = statement_of_work
    end

    def data
      Analytics::Finances::ProjectCalculator.new(@statement_of_work, @start_date, @end_date).data
    end
  end
end
