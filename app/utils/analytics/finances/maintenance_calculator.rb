# frozen_string_literal: true

module Analytics
  module Finances
    class MaintenanceCalculator < FinancesCalculator
      def total_executed_income
        income
      end

      def total_expected_income
        income
      end

      def total_expected_cost
        @financial_item.sum(&:expected_cost)
      end

      def total_executed_cost
        @financial_item.sum(&:executed_cost)
      end

      private

      def income
        (@statement_of_work.total_revenue || 0) * months_difference
      end

      def months_difference
        month_diff = ((@end_date.year * 12) + @end_date.month) - ((@start_date.year * 12) + @start_date.month)
        month_diff += 1 if @start_date.day == 1 && @end_date.day == Date.new(@end_date.year, @end_date.month, -1).day

        month_diff
      end

      def assigned_executed_income(assignment)
        assignment_value(assignment)
      end

      def assigned_expected_income(assignment)
        assignment_value(assignment)
      end

      def assignment_value(assignment)
        (assignment.coverage / @statement_of_work.requirements.sum(&:coverage)) * @statement_of_work.total_revenue
      end
    end
  end
end
