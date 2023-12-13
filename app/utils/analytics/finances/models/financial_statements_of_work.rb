# frozen_string_literal: true

module Analytics
  module Finances
    module Models
      class FinancialStatementsOfWork < FinancialReport
        def initialize(statement_of_works, start_date, end_date, resource_level = true)
          @statement_of_works = statement_of_works

          @resource_level = resource_level
          super(start_date, end_date)
        end

        def calculate!
          @statement_of_works.each do |statement_of_work|
            statement_of_work_start_date = statement_of_work.start_date.to_datetime

            executed_income_to_start_date = 0
            if @start_date > statement_of_work_start_date
              report_to_date = StatementOfWorkFinancialReport.where(statement_of_work:).ending_on(@start_date - 1.day).first
              executed_income_to_start_date = report_to_date&.total_executed_income || 0
            end

            model_calculator = Calculators::CalculatorBuilder.build(statement_of_work, @start_date, @end_date,
                                                                    executed_income_to_start_date)

            add_executed_income(model_calculator.total_executed_income)
            add_expected_income(model_calculator.total_expected_income)
            add_executed_cost(model_calculator.total_executed_cost)
            add_expected_cost(model_calculator.total_expected_cost)

            model_calculator.financial_items.each do |financial_item|
              name = financial_item_name(financial_item, statement_of_work)
              existing_item = financial_item_by_name(name, financial_item.slug)
              existing_item.merge(financial_item)

              next if @resource_level

              existing_item.executed_income = model_calculator.total_executed_income
              existing_item.expected_income = model_calculator.total_expected_income
              existing_item.slug = statement_of_work.project.slug
            end
          end
        end

        def financial_item_name(financial_item, statement_of_work)
          return financial_item.name if @resource_level

          sow_name(statement_of_work)
        end

        def sow_name(sow)
          "#{sow.project.name} - #{sow.name} #{sow.start_date.strftime('%m/%d/%y')} - #{sow.end_date.strftime('%m/%d/%y')}"
        end
      end
    end
  end
end
