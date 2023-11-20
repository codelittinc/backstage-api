# frozen_string_literal: true

module Analytics
  module Finances
    class FixedBidCalculator < FinancesCalculator
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

        calculate!
      end

      def total_executed_income
        total_payments
      end

      def total_expected_income
        total_payments
      end

      def total_expected_cost
        @expected_cost_hash.values.sum
      end

      def total_executed_cost
        @executed_cost_hash.values.sum
      end

      def total_payments
        @total_payments ||= @statement_of_work.payments.executed_between(@start_date, @end_date).sum(:amount)
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
            expected_cost: @expected_cost_hash[name]
          }
        end
      end

      private

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
        end
      end

      def assigned_executed_income(_assignment)
        0
      end

      def assigned_expected_income(_assignment)
        0
      end
    end
  end
end
