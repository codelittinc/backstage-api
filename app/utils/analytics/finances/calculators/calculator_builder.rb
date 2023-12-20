# frozen_string_literal: true

module Analytics
  module Finances
    module Calculators
      class CalculatorBuilder
        def self.build(statement_of_work, start_date, end_date, executed_income_to_start_date = 0)
          case statement_of_work.contract_model_type
          when 'MaintenanceContractModel'
            MaintenanceCalculator.new(statement_of_work, start_date, end_date)
          when 'RetainerContractModel'
            RetainerCalculator.new(statement_of_work, start_date, end_date)
          when 'TimeAndMaterialsContractModel'
            TimeAndMaterialsCalculator.new(statement_of_work, start_date, end_date, executed_income_to_start_date)
          when 'TimeAndMaterialsAtCostContractModel'
            TimeAndMaterialsAtCostCalculator.new(statement_of_work, start_date, end_date,
                                                 executed_income_to_start_date)
          when 'FixedBidContractModel'
            FixedBidCalculator.new(statement_of_work, start_date, end_date)
          end
        end
      end
    end
  end
end
