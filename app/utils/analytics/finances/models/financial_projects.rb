# frozen_string_literal: true

module Analytics
  module Finances
    module Models
      class FinancialProjects < FinancialReport
        def calculate!
          projects.each do |project|
            finances = Analytics::Finances::Models::FinancialStatementsOfWork.new(project, @start_date, @end_date,
                                                                                  false)

            add_executed_income(finances.total_executed_income)
            add_expected_income(finances.total_expected_income)
            add_executed_cost(finances.total_executed_cost)
            add_expected_cost(finances.total_expected_cost)

            finances.financial_items.each do |financial_item|
              existing_item = financial_item_by_name(financial_item.name, project.slug)
              existing_item.merge(financial_item)
            end
          end
        end

        private

        def projects
          Project.active_in_period(@start_date, @end_date)
        end
      end
    end
  end
end
