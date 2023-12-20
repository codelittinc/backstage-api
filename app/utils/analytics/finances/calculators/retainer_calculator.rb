# frozen_string_literal: true

module Analytics
  module Finances
    module Calculators
      class RetainerCalculator < FinancesCalculator
        def total_executed_income
          income
        end

        def total_expected_income
          income
        end

        private

        def income
          @statement_of_work.contract_model.expected_income(@start_date, @end_date)
        end

        def months_difference
          month_diff = ((@end_date.year * 12) + @end_date.month) - ((@start_date.year * 12) + @start_date.month)
          month_diff += 1 if @start_date.day == 1 && @end_date.day == Date.new(@end_date.year, @end_date.month, -1).day

          month_diff
        end

        def assigned_executed_income(_assignment)
          0
        end

        def assigned_expected_income(_assignment)
          0
        end

        def expected_hours(assignment)
          statement_of_work_total_hours = assignment.requirement.statement_of_work.total_hours
          return super if statement_of_work_total_hours.zero?

          assignment.requirement.statement_of_work.total_hours * assignment.coverage
        end
      end
    end
  end
end
