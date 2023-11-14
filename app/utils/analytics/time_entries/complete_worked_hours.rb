# frozen_string_literal: true

module Analytics
  module TimeEntries
    class CompleteWorkedHours
      def initialize(assignment, start_date, end_date)
        @assignment = assignment
        @start_date = [assignment.start_date.to_datetime.beginning_of_day, start_date.to_datetime.beginning_of_day].max
        @end_date = [assignment.end_date.to_datetime.beginning_of_day, end_date.to_datetime.beginning_of_day].min
      end

      def data
        time_entries.sum(&:hours)
      end

      def time_entries
        TimeEntry.where(
          statement_of_work: @assignment.requirement.statement_of_work,
          date: @start_date..@end_date,
          user: @assignment.user
        )
      end
    end
  end
end
