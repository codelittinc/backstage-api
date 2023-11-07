# frozen_string_literal: true

module Analytics
  class TimeEntriesAnalytics
    def initialize(statement_of_work, start_date, end_date)
      @statement_of_work = statement_of_work
      @start_date = start_date.to_datetime
      @end_date = end_date.to_datetime
    end

    # rubocop:disable Style/Metrics/AbcSize
    def data
      {
        labels: users.map(&:name),
        datasets: [
          { label: 'Worked', data: assignments.map(&method(:clean_worked_hours)) },
          { label: 'Missing', data: assignments.map(&method(:missing_hours)) },
          { label: 'Paid time off', data: assignments.map(&method(:vacation_hours)) },
          { label: 'Sick leave', data: assignments.map(&method(:sick_leave_hours)) },
          { label: 'Over delivered', data: assignments.map(&method(:over_delivered_hours)) }
        ]
      }
    end
    # rubocop:enable Style/Metrics/AbcSize

    def assignments
      @assignments ||= Assignment.where(requirement: requirements)
    end

    def requirements
      @requirements ||=
        @statement_of_work.requirements.where('start_date <= ? AND end_date >= ?', @start_date, @end_date)
    end

    def over_delivered_hours(assignment)
      worked = worked_hours(assignment)
      expected = expected_hours(assignment)

      expected > worked ? 0 : worked - expected
    end

    def clean_worked_hours(assignment)
      [worked_hours(assignment), expected_hours(assignment)].min
    end

    def worked_hours(assignment)
      time_entries = TimeEntry.where(statement_of_work: @statement_of_work, date: @start_date..@end_date,
                                     user: assignment.user)

      time_entries.sum(&:hours)
    end

    def expected_hours(assignment)
      days = (@start_date..@end_date).count { |d| !d.sunday? && !d.saturday? }
      days * assignment.coverage * 8
    end

    def missing_hours(assignment)
      worked = worked_hours(assignment)

      [[expected_hours(assignment) - worked, 0].max - vacation_hours(assignment) - sick_leave_hours(assignment), 0].max
    end

    def vacation_hours(assignment)
      vacation_type = TimeOffType.find_by(name: TimeOffType::VACATION_TYPE)
      paid_time_off_hours(assignment, vacation_type)
    end

    def sick_leave_hours(assignment)
      sick_leave_type = TimeOffType.find_by(name: TimeOffType::SICK_LEAVE_TYPE)
      paid_time_off_hours(assignment, sick_leave_type)
    end

    # rubocop:disable Style/Metrics/MethodLength
    # rubocop:disable Style/Metrics/AbcSize
    def paid_time_off_hours(assignment, time_off_type)
      time_offs = time_offs_by_user_and_type(assignment.user, time_off_type)

      time_offs.reduce(0) do |accumulator, time_off|
        start_date = [time_off.starts_at, @start_date].max
        end_date = [time_off.ends_at, @end_date].min
        hours = 0

        current_date = start_date
        while current_date <= end_date
          next(0) if current_date.saturday? || current_date.sunday?

          if current_date == end_date
            hours = 8
          else
            hours += [(end_date - current_date) / 3600, 8].min
          end

          current_date = current_date.next_day
        end

        accumulator + hours
      end
    end
    # rubocop:enable Style/Metrics/AbcSize
    # rubocop:enable Style/Metrics/MethodLength

    def users
      @users ||= assignments.map(&:user)
    end

    def time_offs_by_user_and_type(user, time_off_type)
      TimeOff.where(user:, time_off_type:).where(
        'starts_at <= ? AND ends_at >= ?', @end_date, @start_date
      )
    end
  end
end
