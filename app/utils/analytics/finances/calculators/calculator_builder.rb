# frozen_string_literal: true

module Analytics
  module Finances
    module Calculators
      class CalculatorBuilder
        def self.build(statement_of_work, start_date, end_date)
          case statement_of_work.model
          when 'maintenance'
            MaintenanceCalculator.new(statement_of_work, start_date, end_date)
          when 'time_and_materials'
            TimeAndMaterialsCalculator.new(statement_of_work, start_date, end_date)
          when 'fixed_bid'
            FixedBidCalculator.new(statement_of_work, start_date, end_date)
          end
        end
      end
    end
  end
end
