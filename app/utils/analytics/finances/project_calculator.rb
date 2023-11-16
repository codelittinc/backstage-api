# frozen_string_literal: true

module Analytics
  module Finances
    class ProjectCalculator
      KEYS = %i[
        executed_hours
        expected_hours
        executed_income
        expected_income
        paid_time_off_hours
        executed_cost
        expected_cost
      ].freeze

      def initialize(project, start_date, end_date)
        @project = project
        @start_date = start_date
        @end_date = end_date
      end

      def data
        data = {
          totals: {
            total_expected_income: 0,
            total_executed_income: 0,
            total_executed_cost: 0,
            total_expected_cost: 0
          },
          details: []
        }

        statements_of_work.each do |statement_of_work|
          modeCalculator = calculator(statement_of_work).new(statement_of_work, @start_date, @end_date)
          data[:totals][:total_expected_income] += modeCalculator.total_expected_income
          data[:totals][:total_executed_income] += modeCalculator.total_executed_income

          data[:totals][:total_expected_cost] += modeCalculator.total_expected_cost
          data[:totals][:total_executed_cost] += modeCalculator.total_executed_cost

          details = modeCalculator.details

          details.each do |detail|
            item = data[:details].find { |d| d[:name] == detail[:name] }

            if item
              KEYS.each do |key|
                item[key] += detail[key]
              end
            else
              data[:details] << detail
            end
          end
        end

        data
      end

      private

      def statements_of_work
        statements = @project ? @project.statement_of_works : StatementOfWork.all
        statements.active_in_period(@start_date, @end_date) if @project
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
