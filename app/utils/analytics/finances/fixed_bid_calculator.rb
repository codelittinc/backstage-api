# frozen_string_literal: true

module Analytics
  module Finances
    class FixedBidCalculator < FinancesCalculator
      def total_executed_income
        total_payments
      end

      def total_expected_income
        total_payments
      end

      def total_expected_cost
        @financial_item.sum(&:expected_cost)
      end

      def total_executed_cost
        @financial_item.sum(&:executed_cost)
      end

      def total_payments
        @total_payments ||= @statement_of_work.payments.executed_between(@start_date, @end_date).sum(:amount)
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
