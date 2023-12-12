# frozen_string_literal: true

module Analytics
  module Finances
    module Models
      class FinancialStatementsOfWork < FinancialReport
        def initialize(project, start_date, end_date)
          @project = project
          super(start_date, end_date)
        end

        def calculate!
          @project.statement_of_works.active_in_period(@start_date, @end_date).each do |statement_of_work|
            model_calculator = calculator(statement_of_work).new(statement_of_work, @start_date, @end_date)

            add_executed_income(model_calculator.total_executed_income)
            add_expected_income(model_calculator.total_expected_income)
            add_executed_cost(model_calculator.total_executed_cost)
            add_expected_cost(model_calculator.total_expected_cost)

            model_calculator.details.each do |financial_item|
              existing_item = financial_item_by_name(financial_item.name, financial_item.slug)
              existing_item.merge(financial_item)
            end
          end
        end

        def calculator(statement_of_work)
          case statement_of_work.model
          when 'maintenance'
            Analytics::Finances::MaintenanceCalculator
          when 'time_and_materials'
            Analytics::Finances::TimeAndMaterialsCalculator
          when 'fixed_bid'
            Analytics::Finances::FixedBidCalculator
          end
        end
      end
    end
  end
end
