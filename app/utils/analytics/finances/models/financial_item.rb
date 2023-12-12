# frozen_string_literal: true

module Analytics
  module Finances
    module Models
      class FinancialItem
        attr_accessor :name,
                      :slug,
                      :expected_hours,
                      :executed_hours,
                      :expected_income,
                      :executed_income,
                      :paid_time_off_hours,
                      :executed_cost,
                      :expected_cost

        def initialize(name, slug)
          @name = name
          @slug = slug
          @expected_hours = 0
          @executed_hours = 0
          @expected_income = 0
          @executed_income = 0
          @paid_time_off_hours = 0
          @executed_cost = 0
          @expected_cost = 0
        end

        def add_executed_income(amount)
          @executed_income += amount
        end

        def add_expected_income(amount)
          @expected_income += amount
        end

        def add_executed_cost(amount)
          @executed_cost += amount
        end

        def add_expected_cost(amount)
          @expected_cost += amount
        end

        def add_executed_hours(amount)
          @executed_hours += amount
        end

        def add_expected_hours(amount)
          @expected_hours += amount
        end

        def add_paid_time_off_hours(amount)
          @paid_time_off_hours += amount
        end

        def merge(financial_item)
          add_executed_income(financial_item.executed_income)
          add_expected_income(financial_item.expected_income)
          add_executed_cost(financial_item.executed_cost)
          add_expected_cost(financial_item.expected_cost)
          add_executed_hours(financial_item.executed_hours)
          add_expected_hours(financial_item.expected_hours)
          add_paid_time_off_hours(financial_item.paid_time_off_hours)
        end
      end
    end
  end
end
