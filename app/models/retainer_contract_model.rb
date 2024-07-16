# frozen_string_literal: true

# == Schema Information
#
# Table name: retainer_contract_models
#
#  id                        :bigint           not null, primary key
#  charge_upfront            :boolean          default(FALSE), not null
#  expected_hours_per_period :float            default(0.0)
#  revenue_per_period        :float
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#
class RetainerContractModel < ApplicationRecord
  include Calculable

  has_one :statement_of_work, as: :contract_model, dependent: :destroy

  def contract_total_hours
    expected_hours_per_period * months_in_period(statement_of_work.start_date, statement_of_work.end_date)
  end

  def expected_income(start_date, end_date)
    revenue_per_period * months_in_period(start_date, end_date)
  end

  def months_in_period(start_date, end_date)
    return 1 if start_date.month == end_date.month && start_date.year == end_date.year

    ((end_date.year * 12) + end_date.month) - ((start_date.year * 12) + start_date.month) + 1
  end

  def assignment_executed_income(_assignment, _start_date, _end_date)
    0
  end

  def assignment_expected_income(_assignment, _start_date, _end_date)
    0
  end
end
