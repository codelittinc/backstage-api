# frozen_string_literal: true

module Analytics
  module Finances
    module Calculators
      class TimeAndMaterialsAtCostCalculator < FinancesCalculator
        attr_reader :total_executed_income, :total_expected_income

        def initialize(statement_of_work, start_date, end_date, executed_income_to_start_date = 0)
          @total_executed_income = 0
          @total_expected_income = 0
          @executed_income_to_start_date = executed_income_to_start_date

          super(statement_of_work, start_date, end_date)
        end

        def income_limit
          @statement_of_work.total_revenue
        end

        def add_executed_income(income)
          return income if @statement_of_work.allow_revenue_overflow?

          income_to_add = 0
          if (@total_executed_income + income + @executed_income_to_start_date) >= income_limit
            income_to_add = [income_limit - @total_executed_income - @executed_income_to_start_date, 0].max

            @total_executed_income = income_to_add
          else
            income_to_add = income
            @total_executed_income += income
          end

          income_to_add
        end

        def add_expected_income(income)
          if @total_expected_income + income + @executed_income_to_start_date > income_limit
            income_to_add = [income_limit - @total_expected_income - @executed_income_to_start_date, 0].max
            @total_expected_income = income_to_add
          else
            income_to_add = income
            @total_expected_income += income
          end

          income_to_add
        end
      end
    end
  end
end