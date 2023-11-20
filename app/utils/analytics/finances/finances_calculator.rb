# frozen_string_literal: true

module Analytics
  module Finances
    class FinancesCalculator
      def initialize(statement_of_work, start_date, end_date)
        @statement_of_work = statement_of_work
        @start_date = start_date
        @end_date = end_date
      end

      def assignments
        @assignments ||= Assignment.where(requirement: requirements)
                                   .active_in_period(@start_date, @end_date).joins(:user).order('users.first_name',
                                                                                                'users.last_name')
      end

      def requirements
        Requirement.where(statement_of_work: @statement_of_work).active_in_period(@start_date, @end_date)
      end

      def expected_hours(assignment)
        [TimeEntries::ExpectedHours.new(assignment, @start_date, @end_date).data - paid_time_off_hours(assignment),
         0].max
      end

      def paid_time_off_hours(assignment)
        TimeEntries::PaidTimeOffHours.new(assignment, @start_date, @end_date, TimeOffType.all).data
      end

      def executed_hours(assignment)
        TimeEntries::CompleteWorkedHours.new(assignment, @start_date, @end_date).data
      end

      def assignment_expected_cost(assignment)
        start_date = assignment.start_date
        end_date = assignment.end_date
        work_days = ([start_date, @start_date].max...[end_date, @end_date].min).select do |date|
          (1..5).cover?(date.wday)
        end

        work_days.map do |work_day|
          salary = assignment.user.salary_on_date(work_day)

          8 * (salary&.hourly_cost || 0)
        end.sum
      end

      def assignment_executed_cost(assignment)
        entries = TimeEntries::CompleteWorkedHours.new(assignment, @start_date, @end_date).time_entries
        entries.map do |time_entry|
          date = time_entry.date
          salary = assignment.user.salary_on_date(date)

          time_entry.hours * (salary&.hourly_cost || 0)
        end.sum
      end
    end
  end
end
