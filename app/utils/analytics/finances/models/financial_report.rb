# frozen_string_literal: true

module Analytics
  module Finances
    module Models
      class FinancialReport
        attr_reader :total_executed_income,
                    :total_expected_income,
                    :total_executed_cost,
                    :total_expected_cost,
                    :financial_items

        def initialize(start_date, end_date)
          @total_executed_income = 0
          @total_expected_income = 0
          @total_executed_cost = 0
          @total_expected_cost = 0

          @start_date = start_date
          @end_date = end_date

          @financial_items = []

          calculate!
        end

        private

        def financial_item_by_name(name, slug)
          financial_resource = @financial_items.find { |assignment| assignment.name == name }

          return financial_resource if financial_resource

          financial_resource = Analytics::Finances::Models::FinancialItem.new(name, slug)

          @financial_items << financial_resource
          financial_resource
        end

        def add_executed_income(amount)
          @total_executed_income += amount
        end

        def add_expected_income(amount)
          @total_expected_income += amount
        end

        def add_executed_cost(amount)
          @total_executed_cost += amount
        end

        def add_expected_cost(amount)
          @total_expected_cost += amount
        end
      end
    end
  end
end
