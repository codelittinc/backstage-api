# frozen_string_literal: true

module Analytics
  class CompanyFinancesAnalytics
    def initialize(start_date, end_date, _project)
      @start_date = start_date.to_datetime.beginning_of_day
      @end_date = end_date.to_datetime.end_of_day
    end

    def data
      merged_data = Finances::ProjectCalculator::DEFAULT_DATA

      analytics.each do |project_analytics|
        totals = project_analytics[:data][:totals]
        sum_hash_values(merged_data[:totals].keys, merged_data[:totals], totals)

        details = project_analytics[:data][:details]

        project_merged_data = {
          name: project_analytics[:project].name
        }

        details.each do |detail|
          Finances::ProjectCalculator::KEYS.each do |key|
            project_merged_data[key] = detail[key] + (project_merged_data[key] || 0)
          end
        end

        Finances::ProjectCalculator::KEYS.each do |key|
          project_merged_data[key] = project_merged_data[key] || 0
        end

        merged_data[:details] << project_merged_data
      end

      merged_data
    end

    private

    def sum_hash_values(keys, hash1, hash2)
      keys.each do |key|
        hash1[key] += hash2[key]
      end
    end

    def analytics
      Project.where(billable: true).map do |project|
        {
          project:,
          data: Analytics::ProjectFinancesAnalytics.new(@start_date, @end_date, project).data
        }
      end
    end
  end
end
