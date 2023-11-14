# frozen_string_literal: true

module Analytics
  class ProjectFinancesAnalytics
    def initialize(start_date, end_date, project)
      @start_date = start_date.to_datetime.beginning_of_day
      @end_date = end_date.to_datetime.end_of_day
      @project = project
    end

    # rubocop:disable Metrics/AbcSize
    # rubocop:disable Metrics/MethodLength
    def data
      name_hash = Hash.new(0)
      executed_hours_hash = Hash.new(0)
      paid_time_off_hours_hash = Hash.new(0)
      expected_hours_hash = Hash.new(0)
      executed_income_hash = Hash.new(0)
      expected_income_hash = Hash.new(0)
      expected_cost_hash = Hash.new(0)

      executed_cost_hash = Hash.new(0)

      assignments.each do |assignment|
        user_name = assignment.user.name
        name_hash[user_name] = user_name
        executed_hours_hash[user_name] += executed_hours(assignment)
        paid_time_off_hours_hash[user_name] = paid_time_off_hours(assignment)
        expected_hours_hash[user_name] += expected_hours(assignment)
        executed_income_hash[user_name] += worked_income(assignment)
        expected_income_hash[user_name] += expected_income(assignment)
        expected_cost_hash[user_name] += expected_cost(assignment)
        executed_cost_hash[user_name] += executed_cost(assignment)
      end

      name_hash.keys.map do |name|
        {
          name:,
          executed_hours: executed_hours_hash[name],
          expected_hours: [expected_hours_hash[name], 0].max,

          executed_income: executed_income_hash[name],
          expected_income: expected_income_hash[name],

          paid_time_off_hours: paid_time_off_hours_hash[name],

          executed_cost: executed_cost_hash[name],
          expected_cost: expected_cost_hash[name]
        }
      end
    end

    # rubocop:enable Metrics/MethodLength
    # rubocop:enable Metrics/AbcSize

    # rubocop:disable Metrics/AbcSize
    # rubocop:disable Metrics/MethodLength
    def expected_cost(assignment)
      entries = TimeEntries::ExpectedHours.new(assignment, @start_date, @end_date).entries
      total_cost = entries.map do |time_entry|
        date = time_entry[:date]
        salary = assignment.user.salary_on_date(date)

        time_entry[:hours] * (salary&.hourly_cost || 0)
      end.sum

      pto_entries = TimeEntries::PaidTimeOffHours.new(assignment, @start_date, @end_date, TimeOffType.all).entries
      total_paid_time_off_cost = pto_entries.map do |time_entry|
        date = time_entry[:date]
        salary = assignment.user.salary_on_date(date)

        time_entry[:hours] * (salary&.hourly_cost || 0) * assignment.coverage
      end.sum
      total_cost - total_paid_time_off_cost
    end
    # rubocop:enable Metrics/MethodLength
    # rubocop:enable Metrics/AbcSize

    def executed_cost(assignment)
      entries = TimeEntries::CompleteWorkedHours.new(assignment, @start_date, @end_date).time_entries
      entries.map do |time_entry|
        date = time_entry.date
        salary = assignment.user.salary_on_date(date)

        time_entry.hours * (salary&.hourly_cost || 0)
      end.sum
    end

    def assignments
      @assignments ||= Assignment.where(requirement: requirements)
                                 .active_in_period(@start_date, @end_date).joins(:user).order('users.first_name',
                                                                                              'users.last_name')
    end

    def requirements
      statements = @project.statement_of_works.maintenance
      Requirement.where(statement_of_work: statements).active_in_period(@start_date, @end_date)
    end

    def executed_hours(assignment)
      TimeEntries::CompleteWorkedHours.new(assignment, @start_date, @end_date).data
    end

    def worked_income(assignment)
      hours = executed_hours(assignment)
      hourly_statement = assignment.requirement.statement_of_work.hourly_revenue
      hours * (hourly_statement || 0)
    end

    def expected_income(assignment)
      hours = expected_hours(assignment)
      hourly_statement = assignment.requirement.statement_of_work.hourly_revenue
      hours * (hourly_statement || 0)
    end

    def expected_hours(assignment)
      TimeEntries::ExpectedHours.new(assignment, @start_date, @end_date).data - paid_time_off_hours(assignment)
    end

    def paid_time_off_hours(assignment)
      TimeEntries::PaidTimeOffHours.new(assignment, @start_date, @end_date, TimeOffType.all).data
    end
  end
end
