# frozen_string_literal: true

module Analytics
  module Finances
    class MaintenanceCalculator < FinancesCalculator
      def initialize(statement_of_work, start_date, end_date)
        super(statement_of_work, start_date, end_date)

        @names = {}
        @expected_income_hash = Hash.new(0)
        @executed_income_hash = Hash.new(0)

        @expected_cost_hash = Hash.new(0)
        @executed_cost_hash = Hash.new(0)

        @expected_hours_hash = Hash.new(0)
        @executed_hours_hash = Hash.new(0)
        @paid_time_off_hours_hash = Hash.new(0)

        @slug = Hash.new(0)

        calculate!
      end

      def total_executed_income
        income
      end

      def total_expected_income
        income
      end

      def total_expected_cost
        @expected_cost_hash.values.sum
      end

      def total_executed_cost
        @executed_cost_hash.values.sum
      end

      def details
        @names.keys.map do |name|
          {
            name:,
            executed_hours: @executed_hours_hash[name],
            expected_hours: [@expected_hours_hash[name], 0].max,

            executed_income: @executed_income_hash[name],
            expected_income: @expected_income_hash[name],

            paid_time_off_hours: @paid_time_off_hours_hash[name],

            executed_cost: @executed_cost_hash[name],
            expected_cost: @expected_cost_hash[name],

            slug: @slug[name]
          }
        end
      end

      private

      def income
        (@statement_of_work.total_revenue || 0) * months_difference
      end

      def months_difference
        start_date = @start_date
        end_date = @end_date

        month_diff = ((end_date.year * 12) + end_date.month) - ((start_date.year * 12) + start_date.month)

        month_diff += 1 if start_date.day == 1 && end_date.day == Date.new(end_date.year, end_date.month, -1).day

        month_diff
      end

      def calculate!
        assignments.each do |assignment|
          user_name = assignment.user.name
          @names[user_name] = user_name
          @expected_income_hash[user_name] += assigned_expected_income(assignment)
          @executed_income_hash[user_name] += assigned_executed_income(assignment)

          @expected_cost_hash[user_name] += assignment_expected_cost(assignment)
          @executed_cost_hash[user_name] += assignment_executed_cost(assignment)

          @executed_hours_hash[user_name] += executed_hours(assignment)

          @paid_time_off_hours_hash[user_name] = paid_time_off_hours(assignment)
          @expected_hours_hash[user_name] += expected_hours(assignment)

          @slug[user_name] = assignment.user.slug
        end
      end

      def assigned_executed_income(assignment)
        assignment_value(assignment)
      end

      def assigned_expected_income(assignment)
        assignment_value(assignment)
      end

      def assignment_value(assignment)
        (assignment.coverage / @statement_of_work.requirements.sum(&:coverage)) * @statement_of_work.total_revenue
      end
    end
  end
end
