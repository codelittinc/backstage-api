# frozen_string_literal: true

module Analytics
  module Finances
    class TimeAndMaterialsCalculator < FinancesCalculator
      def total_executed_income
        @executed_income_hash.values.sum
      end

      def total_expected_income
        @expected_income_hash.values.sum
      end

      def total_expected_cost
        @expected_cost_hash.values.sum
      end

      def total_executed_cost
        @executed_cost_hash.values.sum
      end

      def assigned_executed_income(assignment)
        hours = executed_hours(assignment)
        hourly_statement = assignment.requirement.statement_of_work.hourly_revenue
        hours * (hourly_statement || 0)
      end

      def assigned_expected_income(assignment)
        hours = expected_hours(assignment)
        hourly_statement = assignment.requirement.statement_of_work.hourly_revenue
        hours * (hourly_statement || 0)
      end
    end
  end
end
