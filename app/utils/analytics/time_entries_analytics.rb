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
      expected_hours_hash = Hash.new(0)

      # Iterate over assignments to sum the hours for each user
      assignments.each do |assignment|
        user_name = assignment.user.name
        worked_hash[user_name] += worked_hours(assignment)
        missing_hash[user_name] += missing_hours(assignment)
        vacation_hash[user_name] = vacation_hours(assignment)
        sick_leave_hash[user_name] = sick_leave_hours(assignment)
        over_delivered_hash[user_name] += over_delivered_hours(assignment)
        expected_hours_hash[user_name] += expected_hours(assignment)
      end

      final_worked_hash = Hash.new(0)
      final_missing_hash = Hash.new(0)
      final_over_delivered_hash = Hash.new(0)

      assignments.each do |assignment|
        user_name = assignment.user.name
        final_over_delivered_hash[user_name] = [worked_hash[user_name] - expected_hours_hash[user_name], 0].max

        final_worked_hash[user_name] = [worked_hash[user_name] - final_over_delivered_hash[user_name], 0].max

        final_missing_hash[user_name] = [missing_hash[user_name] - over_delivered_hash[user_name], 0].max
      end

      # Create the labels and datasets from the accumulated hashes
      {
        labels: worked_hash.keys,
        datasets: [
          { label: 'Worked', data: final_worked_hash.values },
          { label: 'Paid time off', data: vacation_hash.values },
          { label: 'Sick leave', data: sick_leave_hash.values },
          { label: 'Over delivered', data: final_over_delivered_hash.values },
          { label: 'Missing', data: final_missing_hash.values },
          { label: 'Expected Hours', data: expected_hours_hash.values }
        ]
      }
    end

    # rubocop:enable Metrics/MethodLength
    # rubocop:enable Metrics/AbcSize

    def assignments
      @assignments ||= Assignment.where(requirement: requirements)
                                 .active_in_period(@start_date, @end_date).joins(:user).order('users.first_name',
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
      TimeEntries::CompleteWorkedHours.new(assignment, @start_date, @end_date).data
    end

    def expected_hours(assignment)
      TimeEntries::ExpectedHours.new(assignment, @start_date, @end_date).data
    end

    def missing_hours(assignment)
      worked = worked_hours(assignment)

      [[expected_hours(assignment) - worked, 0].max - vacation_hours(assignment) - sick_leave_hours(assignment), 0].max
    end

    def vacation_hours(assignment)
      vacation_type = TimeOffType.where(name: [TimeOffType::VACATION_TYPE])
      TimeEntries::PaidTimeOffHours.new(assignment, @start_date, @end_date, vacation_type).data
    end

    def sick_leave_hours(assignment)
      sick_leave_type = TimeOffType.find_by(name: TimeOffType::SICK_LEAVE_TYPE)
      TimeEntries::PaidTimeOffHours.new(assignment, @start_date, @end_date, sick_leave_type).data
    end
  end
end
