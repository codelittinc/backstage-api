# frozen_string_literal: true

# == Schema Information
#
# Table name: time_and_materials_at_cost_contract_models
#
#  id                :bigint           not null, primary key
#  allow_overflow    :boolean
#  hours_amount      :float
#  limit_by          :string
#  management_factor :float
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
class TimeAndMaterialsAtCostContractModel < ApplicationRecord
  include Calculable

  has_one :statement_of_work, as: :contract_model, dependent: :destroy

  def assignment_executed_income(assignment, start_date, end_date)
    assignment.executed_cost_in_period(start_date, end_date) * (1 + management_factor)
  end

  def assignment_expected_income(assignment, start_date, end_date)
    assignment.expected_cost_in_period(start_date, end_date) * (1 + management_factor)
  end
end
