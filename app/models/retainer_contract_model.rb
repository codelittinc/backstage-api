# frozen_string_literal: true

# == Schema Information
#
# Table name: retainer_contract_models
#
#  id                 :bigint           not null, primary key
#  charge_upfront     :boolean          default(FALSE), not null
#  revenue_per_period :float
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
class RetainerContractModel < ApplicationRecord
  include Calculable

  has_one :statement_of_work, as: :contract_model, dependent: :destroy

  def assignment_executed_income(_assignment, _start_date, _end_date)
    0
  end

  def assignment_expected_income(_assignment, _start_date, _end_date)
    0
  end
end
