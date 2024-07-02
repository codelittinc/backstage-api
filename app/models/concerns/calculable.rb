# frozen_string_literal: true

module Calculable
  extend ActiveSupport::Concern

  def contract_total_hours
    raise NotImplementedError
  end

  def consumed_hours
    assignments = statement_of_work.requirements.map(&:assignments).flatten
    assignments.sum do |assignment|
      worked_hours(assignment, statement_of_work.start_date, statement_of_work.end_date)
    end
  end

  def expected_hours(assignment, start_date, end_date, include_paid_time_off = false)
    hours = Analytics::TimeEntries::ExpectedHours.new(assignment, start_date, end_date).data
    return hours if include_paid_time_off

    [hours - paid_time_off_hours(assignment, start_date, end_date), 0].max
  end

  def expected_time_entries(assignment, start_date, end_date, include_paid_time_off = false)
    expected_hours(assignment, start_date, end_date, include_paid_time_off)
  end

  def paid_time_off_hours(assignment, start_date, end_date)
    Analytics::TimeEntries::PaidTimeOffHours.new(assignment, start_date, end_date, TimeOffType.all).data
  end

  def vacation_hours(assignment, start_date, end_date)
    vacation_type = TimeOffType.where(name: TimeOffType::VACATION_TYPE)
    Analytics::TimeEntries::PaidTimeOffHours.new(assignment, start_date, end_date, vacation_type).data
  end

  def worked_hours(assignment, start_date, end_date)
    Analytics::TimeEntries::CompleteWorkedHours.new(assignment, start_date, end_date).data
  end

  def over_delivered_hours(worked_hours, expected_hours)
    expected_hours > worked_hours ? 0 : worked_hours - expected_hours
  end

  def sick_leave_hours(assignment, start_date, end_date)
    sick_leave_type = TimeOffType.find_by(name: TimeOffType::SICK_LEAVE_TYPE)
    Analytics::TimeEntries::PaidTimeOffHours.new(assignment, start_date, end_date, sick_leave_type).data
  end

  def errands_hours(assignment, start_date, end_date, missing_hours)
    return 0 if missing_hours.zero?

    errands_type = TimeOffType.find_by(name: TimeOffType::ERRAND_TYPE)
    Analytics::TimeEntries::PaidTimeOffHours.new(assignment, start_date, end_date, errands_type).data
  end

  def missing_hours(worked_hours, expected_hours, vacation_hours, sick_leave_hours)
    [[expected_hours - worked_hours, 0].max - vacation_hours - sick_leave_hours, 0].max
  end

  def assignment_expected_income(_assignment, _start_date, _end_date)
    raise NotImplementedError
  end

  def assignment_executed_income(_assignment, _start_date, _end_date)
    raise NotImplementedError
  end
end
