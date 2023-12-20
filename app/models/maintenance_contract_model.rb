# frozen_string_literal: true

# == Schema Information
#
# Table name: maintenance_contract_models
#
#  id                        :bigint           not null, primary key
#  accumulate_hours          :boolean          default(FALSE), not null
#  charge_upfront            :boolean          default(FALSE), not null
#  delivery_period           :string
#  expected_hours_per_period :float
#  hourly_cost               :float
#  revenue_per_period        :float
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#
class MaintenanceContractModel < ApplicationRecord
  include Calculable

  has_one :statement_of_work, as: :contract_model, dependent: :destroy

  validates :delivery_period, inclusion: { in: %w[weekly monthly] }

  def expected_hours(_assignment, start_date, end_date, _include_paid_time_off = false)
    if delivery_period == 'weekly'
      expected_hours_per_period * weeks_in_period(start_date, end_date)
    else
      expected_hours_per_period * months_in_period(start_date, end_date)
    end
  end

  def paid_time_off_hours(_assignment, _start_date, _end_date)
    0
  end

  def vacation_hours(_assignment, _start_date, _end_date)
    0
  end

  def errands_hours(_assignment, _start_date, _end_date, _missing_hours)
    0
  end

  def sick_leave_hours(_assignment, _start_date, _end_date)
    0
  end

  def assignment_executed_income(_assignment, _start_date, _end_date)
    0
  end

  def assignment_expected_income(_assignment, _start_date, _end_date)
    0
  end

  private

  def weeks_in_period(start_date, end_date)
    (end_date - start_date).to_i / 7
  end

  def months_in_period(_start_date, _end_date)
    def months_in_period(start_date, end_date)
      return 1 if start_date.month == end_date.month && start_date.year == end_date.year

      ((end_date.year * 12) + end_date.month) - ((start_date.year * 12) + start_date.month)
    end
  end
end
