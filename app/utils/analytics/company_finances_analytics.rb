# frozen_string_literal: true

module Analytics
  class CompanyFinancesAnalytics
    def initialize(start_date, end_date, _project)
      @start_date = start_date.to_datetime.beginning_of_day
      @end_date = end_date.to_datetime.end_of_day
    end

    # rubocop:disable Metrics/PerceivedComplexity
    # rubocop:disable Metrics/MethodLength
    # rubocop:disable Metrics/CyclomaticComplexity
    # rubocop:disable Metrics/AbcSize
    def data
      analytics.map do |project_analytics|
        {
          name: project_analytics[:project].name,
          executed_hours: project_analytics[:data].sum { |data| data[:executed_hours] },
          expected_hours: project_analytics[:data].sum { |data| data[:expected_hours] },
          executed_income: project_analytics[:data].sum { |data| data[:executed_income] },
          expected_income: project_analytics[:data].sum { |data| data[:expected_income] },
          paid_time_off_hours: project_analytics[:data].sum { |data| data[:paid_time_off_hours] },
          executed_cost: project_analytics[:data].sum { |data| data[:executed_cost] },
          expected_cost: project_analytics[:data].sum { |data| data[:expected_cost] }
        }
      end
    end
    # rubocop:enable Metrics/AbcSize
    # rubocop:enable Metrics/CyclomaticComplexity
    # rubocop:enable Metrics/MethodLength
    # rubocop:enable Metrics/PerceivedComplexity

    private

    def analytics
      projects = Project.where(billable: true)

      projects.map do |project|
        {
          project:,
          data: Analytics::ProjectFinancesAnalytics.new(@start_date, @end_date, project).data
        }
      end
    end
  end
end
