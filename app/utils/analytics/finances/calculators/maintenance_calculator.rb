# frozen_string_literal: true

module Analytics
  module Finances
    module Calculators
      class MaintenanceCalculator < FinancesCalculator
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

        def assigned_executed_income(_assignment)
          0
        end

        def assigned_expected_income(_assignment)
          0
        end

        def expected_hours(assignment)
          @statement_of_work.contract_model.expected_hours(assignment, @start_date, @end_date, false)
        end
      end
    end
  end
end
