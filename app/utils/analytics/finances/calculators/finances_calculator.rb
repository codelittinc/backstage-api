# frozen_string_literal: true

module Analytics
  module Finances
    module Calculators
      class FinancesCalculator
        attr_reader :financial_items

        def initialize(statement_of_work, start_date, end_date)
          @statement_of_work = statement_of_work
          @start_date = start_date
          @end_date = end_date

          @financial_items = []
          calculate!
        end

        def calculate!
          assignments.each do |assignment|
            financial_resource_assignment = financial_item_by_name(assignment.user.name, assignment.user.slug)

            expected_income = add_expected_income(assignment.expected_income_in_period(@start_date, @end_date))

            financial_resource_assignment.add_expected_income(expected_income)

            executed_income = add_executed_income(assignment.executed_income_in_period(@start_date, @end_date))
            financial_resource_assignment.add_executed_income(executed_income)

            financial_resource_assignment.add_expected_cost(assignment_expected_cost(assignment))
            financial_resource_assignment.add_executed_cost(assignment_executed_cost(assignment))
            financial_resource_assignment.add_executed_hours(executed_hours(assignment))
            financial_resource_assignment.add_expected_hours(expected_hours(assignment))
            financial_resource_assignment.add_paid_time_off_hours(paid_time_off_hours(assignment))
          end
        end

        def add_expected_income(income)
          income
        end

        def add_executed_income(income)
          income
        end

        def assignments
          @assignments ||= Assignment.where(requirement: requirements)
                                     .active_in_period(@start_date, @end_date).joins(:user).order('users.first_name',
                                                                                                  'users.last_name')
        end

        def requirements
          @requirements ||= Requirement.where(statement_of_work: @statement_of_work).active_in_period(@start_date,
                                                                                                      @end_date)
        end

        def expected_hours(assignment)
          assignment.contract_model.expected_hours(assignment, @start_date, @end_date, true)
        end

        def paid_time_off_hours(assignment)
          assignment.contract_model.paid_time_off_hours(assignment, @start_date, @end_date)
        end

        def executed_hours(assignment)
          assignment.contract_model.worked_hours(assignment, @start_date, @end_date)
        end

        def assignment_expected_cost(assignment)
          assignment.expected_cost_in_period(@start_date, @end_date)
        end

        def assignment_executed_cost(assignment)
          assignment.executed_cost_in_period(@start_date, @end_date)
        end

        def financial_item_by_name(name, slug)
          financial_resource = @financial_items.find { |assignment| assignment.name == name }

          return financial_resource if financial_resource

          financial_resource = Analytics::Finances::Models::FinancialItem.new(name, slug)

          @financial_items << financial_resource

          financial_resource
        end

        def total_expected_cost
          @financial_items.sum(&:expected_cost)
        end

        def total_executed_cost
          @financial_items.sum(&:executed_cost)
        end
      end
    end
  end
end
