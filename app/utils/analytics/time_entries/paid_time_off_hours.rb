# frozen_string_literal: true

module Analytics
  module TimeEntries
    class PaidTimeOffHours
      EXPECTED_WORK_HOURS_IN_A_DAY = 8

      def initialize(assignment, start_date, end_date, paid_time_off_type)
        @assignment = assignment
        @start_date = start_date.to_datetime.beginning_of_day
        @end_date = end_date.to_datetime.end_of_day
        @paid_time_off_type = paid_time_off_type
      end

      def data
        ent = entries
        ent.sum { |entry| entry[:hours] }
      end

      def entries
        time_offs = time_offs_by_user_and_type(@assignment.user, @paid_time_off_type)

        final_time_offs = []
        time_offs.each do |time_off|
          start_date = [time_off.starts_at, @start_date].max.to_time
          end_date = [time_off.ends_at, @end_date].min.to_time

          current_date = start_date
          while current_date <= end_date
            unless current_date.saturday? || current_date.sunday?
              hours = [(end_date - current_date) / 3600,
                       EXPECTED_WORK_HOURS_IN_A_DAY].min
              final_time_offs << { date: current_date, hours: }
            end
            current_date = current_date.next_day
          end
        end
        final_time_offs
      end

      private

      def time_offs_by_user_and_type(user, time_off_type)
        TimeOff.where(user:, time_off_type:).active_in_period(@start_date, @end_date)
      end
    end
  end
end
