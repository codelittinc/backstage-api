# frozen_string_literal: true

module Analytics
  module TimeEntries
    class ExpectedHours
      EXPECTED_WORK_HOURS_IN_A_DAY = 8

      def initialize(assignment, start_date, end_date)
        @assignment = assignment
        @start_date = start_date.to_datetime.beginning_of_day
        @end_date = end_date.to_datetime.end_of_day
      end

      def data
        days = ([@start_date, @assignment.start_date].max..[@end_date, @assignment.end_date].min).count do |d|
          !d.sunday? && !d.saturday?
        end

        days * @assignment.coverage * EXPECTED_WORK_HOURS_IN_A_DAY
      end
    end
  end
end
