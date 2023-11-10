# frozen_string_literal: true

module Analytics
  module TimeEntries
    class CompleteWorkedHours
      def initialize(assignment, start_date, end_date)
        @assignment = assignment
        @start_date = start_date.to_datetime.beginning_of_day
        @end_date = end_date.to_datetime.end_of_day
      end

      def data
        TimeEntry.where(
          statement_of_work: @assignment.requirement.statement_of_work,
          date: @start_date..@end_date,
          user: @assignment.user
        ).sum(&:hours)
      end
    end
  end
end
