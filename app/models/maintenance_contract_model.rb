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

  def contract_total_hours
    expected_hours(nil, statement_of_work.start_date.to_date, statement_of_work.end_date.to_date)
  end

  def expected_hours(_assignment, start_date, end_date, _include_paid_time_off = false)
    if delivery_period == 'weekly'
      expected_hours_per_period * weeks_in_period(start_date, end_date)
    else
      expected_hours_per_period * months_in_period(start_date, end_date)
    end
  end

  def expected_time_entries(assignment, start_date, end_date, _include_paid_time_off)
    # Retrieve the 'expected_hours' method from the 'Calculable' module
    method_from_module = Calculable.instance_method(:expected_hours)

    # Bind this method to the current instance and call it
    method_from_module.bind(self).call(assignment, start_date, end_date, true)
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

  def expected_income(start_date, end_date)
    if delivery_period == 'weekly'
      revenue_per_period * weeks_in_period(start_date, end_date)
    else
      revenue_per_period * months_in_period(start_date, end_date)
    end
  end

  private

  def weeks_in_period(start_date, end_date)
    (end_date - start_date).to_i / 7
  end

  def months_in_period(start_date, end_date)
    total_days = (end_date - start_date).to_f

    # Average number of days in a month (approximately)
    average_days_per_month = 30.44

    # Calculate the difference in months as a float
    (total_days / average_days_per_month).round
  end
end
