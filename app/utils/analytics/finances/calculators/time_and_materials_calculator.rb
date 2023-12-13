# frozen_string_literal: true

module Analytics
  module Finances
    module Calculators
      class TimeAndMaterialsCalculator < FinancesCalculator
        def initialize(statement_of_work, start_date, end_date)
          @total_executed_income = 0
          @total_expected_income = 0

          super(statement_of_work, start_date, end_date)
        end

        def income_limit
          @statement_of_work.total_revenue
        end

        attr_reader :total_executed_income, :total_expected_income

        def add_executed_income(income)
          if @total_executed_income + income > income_limit
            income_to_add = income_limit - @total_executed_income
            @total_executed_income = income_limit
          else
            income_to_add = income
            @total_executed_income += income
          end

          income_to_add
        end

        def add_expected_income(income)
          if @total_expected_income + income > income_limit
            income_to_add = income_limit - @total_expected_income
            @total_expected_income = income_limit
          else
            income_to_add = income
            @total_expected_income += income
          end

          income_to_add
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
end
