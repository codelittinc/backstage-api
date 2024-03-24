# frozen_string_literal: true

# == Schema Information
#
# Table name: assignments
#
#  id             :bigint           not null, primary key
#  coverage       :float
#  end_date       :datetime
#  start_date     :datetime
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  requirement_id :bigint           not null
#  user_id        :bigint           not null
#
# Indexes
#
#  index_assignments_on_requirement_id  (requirement_id)
#  index_assignments_on_user_id         (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (requirement_id => requirements.id)
#  fk_rails_...  (user_id => users.id)
#
class Assignment < ApplicationRecord
  belongs_to :requirement
  belongs_to :user

  validates :coverage, presence: true

  scope :active_in_period, ->(start_date, end_date) { where('start_date <= ? AND end_date >= ?', end_date, start_date) }

  def contract_model
    requirement.statement_of_work.contract_model
  end

  def expected_cost_in_period(start_date_filter, end_date_filter)
    period_start = [start_date, start_date_filter].max
    period_end = [end_date, end_date_filter].min

    work_days = (period_start.to_date...period_end.to_date).to_a.select do |date|
      date.wday.between?(1, 5)
    end

    work_days.sum do |work_day|
      salary = user.salary_on_date(work_day)
      8 * (salary&.hourly_cost || 0)
    end * coverage
  end

  def executed_cost_in_period(start_date_filter, end_date_filter)
    entries = Analytics::TimeEntries::CompleteWorkedHours.new(self, start_date_filter, end_date_filter).time_entries
    entries.map do |time_entry|
      date = time_entry.date
      salary = user.salary_on_date(date)

      time_entry.hours * (salary&.hourly_cost || 0)
    end.sum
  end

  def expected_income_in_period(start_date_filter, end_date_filter)
    contract_model.assignment_expected_income(self, start_date_filter, end_date_filter)
  end

  def executed_income_in_period(start_date_filter, end_date_filter)
    contract_model.assignment_executed_income(self, start_date_filter, end_date_filter)
  end
end
