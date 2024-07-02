# frozen_string_literal: true

# == Schema Information
#
# Table name: fixed_bid_contract_models
#
#  id             :bigint           not null, primary key
#  fixed_timeline :boolean          default(FALSE), not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
class FixedBidContractModel < ApplicationRecord
  include Calculable

  has_one :statement_of_work, as: :contract_model, dependent: :destroy

  def contract_total_hours
    consumed_hours
  end

  def assignment_executed_income(_assignment, _start_date, _end_date)
    0
  end

  def assignment_expected_income(_assignment, _start_date, _end_date)
    0
  end
end
