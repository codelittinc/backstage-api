# frozen_string_literal: true

module Analytics
  module Finances
    class FinancesCalculator
      def initialize(statement_of_work, start_date, end_date)
        @statement_of_work = statement_of_work
        @start_date = start_date
        @end_date = end_date

        @financial_item = []
        calculate!
      end

      def details
        @financial_item
      end

      def calculate!
        assignments.each do |assignment|
          financial_resource_assignment = financial_item_by_name(assignment.user.name, assignment.user.slug)
          financial_resource_assignment.add_expected_income(assigned_expected_income(assignment))
          financial_resource_assignment.add_executed_income(assigned_executed_income(assignment))
          financial_resource_assignment.add_expected_cost(assignment_expected_cost(assignment))
          financial_resource_assignment.add_executed_cost(assignment_executed_cost(assignment))
          financial_resource_assignment.add_executed_hours(executed_hours(assignment))
          financial_resource_assignment.add_expected_hours(expected_hours(assignment))
          financial_resource_assignment.add_paid_time_off_hours(paid_time_off_hours(assignment))
        end
      end

      def assignments
        @assignments ||= Assignment.where(requirement: requirements)
                                   .active_in_period(@start_date, @end_date).joins(:user).order('users.first_name',
                                                                                                'users.last_name')
      end

      def requirements
        @requirements ||= Requirement.where(statement_of_work: @statement_of_work).active_in_period(@start_date,
                                                                                                    @end_date)
      end

      def expected_hours(assignment)
        hours = Analytics::TimeEntries::ExpectedHours.new(assignment, @start_date, @end_date).data
        [hours - paid_time_off_hours(assignment), 0].max
      end

      def paid_time_off_hours(assignment)
        Analytics::TimeEntries::PaidTimeOffHours.new(assignment, @start_date, @end_date, TimeOffType.all).data
      end

      def executed_hours(assignment)
        Analytics::TimeEntries::CompleteWorkedHours.new(assignment, @start_date, @end_date).data
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
        entries = Analytics::TimeEntries::CompleteWorkedHours.new(assignment, @start_date, @end_date).time_entries
        entries.map do |time_entry|
          date = time_entry.date
          salary = assignment.user.salary_on_date(date)

          time_entry.hours * (salary&.hourly_cost || 0)
        end.sum
      end

      def financial_item_by_name(name, slug)
        financial_resource = @financial_item.find { |assignment| assignment.name == name }

        return financial_resource if financial_resource

        financial_resource = Analytics::Finances::Models::FinancialItem.new(name, slug)

        @financial_item << financial_resource
        financial_resource
      end
    end
  end
end
