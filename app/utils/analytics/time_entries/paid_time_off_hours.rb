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
        TimeOffType.where(name: [TimeOffType::VACATION_TYPE, TimeOffType::ERRAND_TYPE])
        paid_time_off_hours(@assignment, @paid_time_off_type)
      end

      private

      # rubocop:disable Metrics/MethodLength
      # rubocop:disable Metrics/AbcSize
      def paid_time_off_hours(assignment, time_off_type)
        time_offs = time_offs_by_user_and_type(assignment.user, time_off_type)

        time_offs.reduce(0) do |accumulator, time_off|
          start_date = [time_off.starts_at, @start_date].max.to_time
          end_date = [time_off.ends_at, @end_date].min.to_time
          hours = 0

          current_date = start_date

          while current_date <= end_date
            unless current_date.saturday? || current_date.sunday?
              hours += [(end_date - current_date) / 3600,
                        EXPECTED_WORK_HOURS_IN_A_DAY].min
            end
            current_date = current_date.next_day
          end

          accumulator + hours
        end
      end

      # rubocop:enable Metrics/AbcSize
      # rubocop:enable Metrics/MethodLength

      def time_offs_by_user_and_type(user, time_off_type)
        TimeOff.where(user:, time_off_type:).active_in_period(@start_date, @end_date)
      end
    end
  end
end
