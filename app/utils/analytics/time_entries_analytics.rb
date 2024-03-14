# frozen_string_literal: true

module Analytics
  class TimeEntriesAnalytics
    def initialize(project, statement_of_work, start_date, end_date)
      @project = project
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
      errands_hours_hash = Hash.new(0)

      # Iterate over assignments to sum the hours for each user
      assignments.each do |assignment|
        user_name = assignment.user.name
        contract_model = assignment.contract_model
        worked = contract_model.worked_hours(assignment, @start_date, @end_date)
        expected = contract_model.expected_time_entries(assignment, @start_date, @end_date, true)
        vacation = contract_model.vacation_hours(assignment, @start_date, @end_date)
        sick_leave = contract_model.sick_leave_hours(assignment, @start_date, @end_date)

        worked_hash[user_name] += worked
        missing_hash[user_name] += contract_model.missing_hours(worked, expected, vacation, sick_leave)
        vacation_hash[user_name] = vacation
        sick_leave_hash[user_name] = sick_leave
        over_delivered_hash[user_name] += contract_model.over_delivered_hours(worked, expected)
        expected_hours_hash[user_name] += expected
      end

      final_worked_hash = Hash.new(0)
      final_missing_hash = Hash.new(0)
      final_over_delivered_hash = Hash.new(0)

      assignments.each do |assignment|
        user_name = assignment.user.name
        final_over_delivered_hash[user_name] = [worked_hash[user_name] - expected_hours_hash[user_name], 0].max

        final_worked_hash[user_name] = [worked_hash[user_name] - final_over_delivered_hash[user_name], 0].max

        final_missing_hash[user_name] = [missing_hash[user_name] - over_delivered_hash[user_name], 0].max

        errands_hours_hash[user_name] =
          assignment.contract_model.errands_hours(assignment, @start_date, @end_date, final_missing_hash[user_name])
      end

      # Create the labels and datasets from the accumulated hashes
      {
        labels: worked_hash.keys,
        datasets: [
          { label: 'Worked', data: final_worked_hash.values },
          { label: 'Paid time off', data: vacation_hash.values },
          { label: 'Over delivered', data: final_over_delivered_hash.values },
          { label: 'Sick leave', data: sick_leave_hash.values },
          { label: 'Missing', data: final_missing_hash.values },
          { label: 'Errands', data: errands_hours_hash.values },
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

      @requirements = if @project
                        Requirement.where(id: @project.statement_of_works.map(&:requirements)
                                            .flatten.map(&:id))
                      elsif @statement_of_work
                        Requirement.where(id: @statement_of_work.requirements.map(&:id))
                      else
                        Requirement.all
                      end
      @requirements.active_in_period(@start_date, @end_date)
    end

    def clean_worked_hours(assignment)
      [worked_hours(assignment), expected_hours(assignment)].min
    end
  end
end
