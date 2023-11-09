# frozen_string_literal: true

module Analytics
  class TimeEntriesAnalytics
    def initialize(statement_of_work, start_date, end_date)
      @statement_of_work = statement_of_work
      @start_date = start_date.to_datetime.beginning_of_day
      @end_date = end_date.to_datetime.end_of_day
      @worked_hours_cache = {} # Cache for memoization
    end

    # rubocop:disable Metrics/AbcSize
    # rubocop:disable Metrics/MethodLength
    def data
      # Initialize the hashes to accumulate hours for each user
      worked_hash = Hash.new(0)
      missing_hash = Hash.new(0)
      vacation_hash = Hash.new(0)
      sick_leave_hash = Hash.new(0)
      over_delivered_hash = Hash.new(0)

      # Iterate over assignments to sum the hours for each user
      assignments.each do |assignment|
        user_name = assignment.user.name
        worked_hash[user_name] += clean_worked_hours(assignment)
        missing_hash[user_name] += missing_hours(assignment)
        vacation_hash[user_name] += vacation_hours(assignment)
        sick_leave_hash[user_name] += sick_leave_hours(assignment)
        over_delivered_hash[user_name] += over_delivered_hours(assignment)
      end

      # Create the labels and datasets from the accumulated hashes
      {
        labels: worked_hash.keys,
        datasets: [
          { label: 'Worked', data: worked_hash.values },
          { label: 'Paid time off', data: vacation_hash.values },
          { label: 'Sick leave', data: sick_leave_hash.values },
          { label: 'Over delivered', data: over_delivered_hash.values },
          { label: 'Missing', data: missing_hash.values }
        ]
      }
    end
    # rubocop:enable Metrics/MethodLength
    # rubocop:enable Metrics/AbcSize

    def assignments
      @assignments ||= Assignment.where(requirement: requirements).joins(:user).order('users.first_name',
                                                                                      'users.last_name')
    end

    def requirements
      return @requirements if @requirements

      @requirements = if @statement_of_work
                        @statement_of_work.requirements.active_in_period(@start_date, @end_date)
                      else
                        Requirement.all.active_in_period(@start_date, @end_date)
                      end
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
      return @worked_hours_cache[assignment.id] if @worked_hours_cache.key?(assignment.id)

      time_entries = TimeEntry.where(
        statement_of_work: assignment.requirement.statement_of_work,
        date: (@start_date.beginning_of_day)..@end_date.end_of_day,
        user: assignment.user
      )

      @worked_hours_cache[assignment.id] = time_entries.sum(&:hours)
    end

    def expected_hours(assignment)
      days = ([@start_date, assignment.start_date].max..[@end_date, assignment.end_date].min).count do |d|
        !d.sunday? && !d.saturday?
      end

      days * assignment.coverage * 8
    end

    def missing_hours(assignment)
      worked = worked_hours(assignment)

      [[expected_hours(assignment) - worked, 0].max - vacation_hours(assignment) - sick_leave_hours(assignment), 0].max
    end

    def vacation_hours(assignment)
      vacation_type = TimeOffType.where(name: [TimeOffType::VACATION_TYPE, TimeOffType::ERRAND_TYPE])
      paid_time_off_hours(assignment, vacation_type)
    end

    def sick_leave_hours(assignment)
      sick_leave_type = TimeOffType.find_by(name: TimeOffType::SICK_LEAVE_TYPE)
      paid_time_off_hours(assignment, sick_leave_type)
    end

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
            hours += [(end_date - current_date) / 3600, 8].min
          end
          current_date = current_date.next_day
        end

        accumulator + hours
      end
    end
    # rubocop:enable Metrics/AbcSize
    # rubocop:enable Metrics/MethodLength

    def users
      @users ||= assignments.map(&:user)
    end

    def time_offs_by_user_and_type(user, time_off_type)
      TimeOff.where(user:, time_off_type:).active_in_period(@start_date, @end_date)
    end
  end
end
