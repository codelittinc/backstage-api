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
        entries.sum { |e| e[:hours] }
      end

      def entries
        start_date = [@start_date, @assignment.start_date].max
        end_date = [@end_date, @assignment.end_date].min

        # Convert the range into an array of dates
        days = (start_date.to_date..end_date.to_date).to_a.select do |d|
          d.wday.between?(1, 5) # Exclude Saturday (6) and Sunday (0)
        end

        days.map do |day|
          {
            date: day,
            hours: @assignment.coverage * EXPECTED_WORK_HOURS_IN_A_DAY
          }
        end
      end
    end
  end
end
