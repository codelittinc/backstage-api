# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Analytics::TimeEntriesAnalytics, type: :service do
  let(:project) { create(:project) }
  let(:sow) { create(:statement_of_work, :with_fixed_bid, project:) }
  let(:start_date) { Date.parse('2023/11/29') }
  let(:end_date) { start_date + 6.days }

  describe '#data' do
    context 'when the user puts the information for the entire period' do
      it 'returns the dataset for that SOW' do
        user1 = create(:user)
        create(:time_entry,
               statement_of_work: sow, date: start_date + 1.day, user: user1, hours: 8)
        create(:time_entry,
               statement_of_work: sow, date: start_date + 2.days, user: user1, hours: 8)
        create(:time_entry,
               statement_of_work: sow, date: start_date + 3.days, user: user1, hours: 8)
        create(:time_entry,
               statement_of_work: sow, date: start_date + 4.days, user: user1, hours: 8)
        create(:time_entry,
               statement_of_work: sow, date: start_date + 5.days, user: user1, hours: 8)

        requirement1 = create(:requirement, statement_of_work: sow, coverage: 1, start_date:,
                                            end_date:)

        create(:assignment, requirement: requirement1, user: user1, coverage: 1, start_date:,
                            end_date:)

        data = Analytics::TimeEntriesAnalytics.new(project, start_date, end_date).data
        data_json = data.to_json
        expected_response_json = {
          labels: [user1.name],
          datasets: [
            {
              label: 'Worked',
              data: [40.0]
            },
            {
              label: 'Paid time off',
              data: [0]
            },
            {
              label: 'Over delivered',
              data: [0.0]
            },
            {
              label: 'Sick leave',
              data: [0]
            },
            {
              label: 'Missing',
              data: [0.0]
            },
            {
              label: 'Errands',
              data: [0]
            },
            {
              label: 'Expected Hours',
              data: [40.0]
            }
          ]
        }.to_json
        expect(data_json).to eql(expected_response_json)
      end
    end

    context 'when there are multiple users putting the information for the entire period' do
      it 'returns the dataset for that SOW' do
        user1 = create(:user)
        user2 = create(:user)
        user3 = create(:user)

        # user 1
        create(:time_entry,
               statement_of_work: sow, date: start_date + 1.day, user: user1, hours: 8)
        create(:time_entry,
               statement_of_work: sow, date: start_date + 2.days, user: user1, hours: 8)
        create(:time_entry,
               statement_of_work: sow, date: start_date + 3.days, user: user1, hours: 8)
        create(:time_entry,
               statement_of_work: sow, date: start_date + 4.days, user: user1, hours: 8)
        create(:time_entry,
               statement_of_work: sow, date: start_date + 5.days, user: user1, hours: 8)

        # user 2
        create(:time_entry,
               statement_of_work: sow, date: start_date + 1.day, user: user2, hours:  4)
        create(:time_entry,
               statement_of_work: sow, date: start_date + 2.days, user: user2, hours: 4)
        create(:time_entry,
               statement_of_work: sow, date: start_date + 3.days, user: user2, hours: 4)
        create(:time_entry,
               statement_of_work: sow, date: start_date + 4.days, user: user2, hours: 4)
        create(:time_entry,
               statement_of_work: sow, date: start_date + 5.days, user: user2, hours: 4)
        # user 3
        create(:time_entry,
               statement_of_work: sow, date: start_date + 1.day, user: user3, hours: 4)
        create(:time_entry,
               statement_of_work: sow, date: start_date + 2.days, user: user3, hours: 4)
        create(:time_entry,
               statement_of_work: sow, date: start_date + 3.days, user: user3, hours: 4)
        create(:time_entry,
               statement_of_work: sow, date: start_date + 4.days, user: user3, hours: 4)
        create(:time_entry,
               statement_of_work: sow, date: start_date + 5.days, user: user3, hours: 4)

        requirement1 = create(:requirement, statement_of_work: sow, coverage: 1, start_date:,
                                            end_date:)

        create(:requirement, statement_of_work: sow, coverage: 1, start_date:,
                             end_date:)

        create(:assignment, requirement: requirement1, user: user1, coverage: 1, start_date:,
                            end_date:)

        create(:assignment, requirement: requirement1, user: user2, coverage: 0.5, start_date:,
                            end_date:)
        create(:assignment, requirement: requirement1, user: user3, coverage: 0.5, start_date:,
                            end_date:)

        data = Analytics::TimeEntriesAnalytics.new(project, start_date, end_date).data
        data_json = data.to_json
        sorted_data = {
          user1.id => [40.0, 0.0, 0, 0, 0.0, 0, 40.0],
          user2.id => [20.0, 0.0, 0, 0, 0.0, 0, 20.0],
          user3.id => [20.0, 0.0, 0, 0, 0.0, 0, 20.0]
        }
        users = [user1, user2, user3].sort_by(&:first_name)

        expected_response_json = {
          labels: users.map(&:name),
          datasets: [
            {
              label: 'Worked',
              data: users.map { |user| sorted_data[user.id][0] }
            },
            {
              label: 'Paid time off',
              data: users.map { |user| sorted_data[user.id][2] }
            },
            {
              label: 'Over delivered',
              data: users.map { |user| sorted_data[user.id][4] }
            },
            {
              label: 'Sick leave',
              data: users.map { |user| sorted_data[user.id][3] }
            },
            {
              label: 'Missing',
              data: users.map { |user| sorted_data[user.id][1] }
            },
            {
              label: 'Errands',
              data: users.map { |user| sorted_data[user.id][5] }
            },
            {
              label: 'Expected Hours',
              data: users.map { |user| sorted_data[user.id][6] }
            }
          ]
        }.to_json
        expect(data_json).to eql(expected_response_json)
      end
    end

    context 'when the user does not add 5 hours for that period' do
      it 'returns 5 hours as missing' do
        user1 = create(:user)

        create(:time_entry, statement_of_work: sow, date: start_date + 1.day, user: user1, hours: 3)
        create(:time_entry, statement_of_work: sow, date: start_date + 2.days, user: user1, hours: 8)
        create(:time_entry, statement_of_work: sow, date: start_date + 3.days, user: user1, hours: 8)
        create(:time_entry, statement_of_work: sow, date: start_date + 4.days, user: user1, hours: 8)
        create(:time_entry, statement_of_work: sow, date: start_date + 5.days, user: user1, hours: 8)

        requirement1 = create(:requirement, statement_of_work: sow, coverage: 1, start_date:,
                                            end_date:)

        create(:assignment, requirement: requirement1, user: user1, coverage: 1, start_date:,
                            end_date:)

        data = Analytics::TimeEntriesAnalytics.new(project, start_date, end_date).data
        data_json = data.to_json
        expected_response_json = {
          labels: [user1.name],
          datasets: [
            {
              label: 'Worked',
              data: [35.0]
            },
            {
              label: 'Paid time off',
              data: [0]
            },
            {
              label: 'Over delivered',
              data: [0]
            },
            {
              label: 'Sick leave',
              data: [0]
            },
            {
              label: 'Missing',
              data: [5.0]
            },
            {
              label: 'Errands',
              data: [0]
            },
            {
              label: 'Expected Hours',
              data: [40.0]
            }
          ]
        }.to_json
        expect(data_json).to eql(expected_response_json)
      end
    end
    context 'when the user a full day of PTO during the period' do
      it 'returns 8 hours as paid time off' do
        user1 = create(:user)

        create(:time_off, :vacation, user: user1, starts_at: start_date.beginning_of_day,
                                     ends_at: (start_date + 1.day).beginning_of_day)

        create(:time_entry, statement_of_work: sow, date: start_date + 2.days, user: user1, hours: 8)
        create(:time_entry, statement_of_work: sow, date: start_date + 3.days, user: user1, hours: 8)
        create(:time_entry, statement_of_work: sow, date: start_date + 4.days, user: user1, hours: 8)
        create(:time_entry, statement_of_work: sow, date: start_date + 5.days, user: user1, hours: 8)

        requirement1 = create(:requirement, statement_of_work: sow, coverage: 1, start_date:,
                                            end_date:)

        create(:assignment, requirement: requirement1, user: user1, coverage: 1, start_date:,
                            end_date:)

        data = Analytics::TimeEntriesAnalytics.new(project, start_date, end_date).data
        data_json = data.to_json
        expected_response_json = {
          labels: [user1.name],
          datasets: [
            {
              label: 'Worked',
              data: [32.0]
            },
            {
              label: 'Paid time off',
              data: [8.0]
            },
            {
              label: 'Over delivered',
              data: [0]
            },
            {
              label: 'Sick leave',
              data: [0]
            },
            {
              label: 'Missing',
              data: [0.0]
            },
            {
              label: 'Errands',
              data: [0]
            },
            {
              label: 'Expected Hours',
              data: [40.0]
            }
          ]
        }.to_json
        expect(data_json).to eql(expected_response_json)
      end
    end

    context 'when the user has 2 hours of PTO during the period' do
      it 'returns 8 hours as paid time off' do
        user1 = create(:user)

        create(:time_off, user: user1, starts_at: start_date + 8.hours, ends_at: start_date + 10.hours)

        create(:time_entry, statement_of_work: sow, date: start_date + 2.days, user: user1, hours: 6)
        create(:time_entry, statement_of_work: sow, date: start_date + 3.days, user: user1, hours: 8)
        create(:time_entry, statement_of_work: sow, date: start_date + 4.days, user: user1, hours: 8)
        create(:time_entry, statement_of_work: sow, date: start_date + 5.days, user: user1, hours: 8)
        create(:time_entry, statement_of_work: sow, date: start_date + 5.days, user: user1, hours: 8)

        requirement1 = create(:requirement, statement_of_work: sow, coverage: 1, start_date:,
                                            end_date:)

        create(:assignment, requirement: requirement1, user: user1, coverage: 1, start_date:,
                            end_date:)

        data = Analytics::TimeEntriesAnalytics.new(project, start_date, end_date).data
        data_json = data.to_json
        expected_response_json = {
          labels: [user1.name],
          datasets: [
            {
              label: 'Worked',
              data: [38.0]
            },
            {
              label: 'Paid time off',
              data: [2.0]
            },
            {
              label: 'Over delivered',
              data: [0]
            },
            {
              label: 'Sick leave',
              data: [0]
            },
            {
              label: 'Missing',
              data: [0.0]
            },
            {
              label: 'Errands',
              data: [0]
            },
            {
              label: 'Expected Hours',
              data: [40.0]
            }
          ]
        }.to_json
        expect(data_json).to eql(expected_response_json)
      end
    end

    context 'when the user has 5 hours of PTO during the period and is missing 5 hours' do
      it 'returns 5 hours of pto and 5 hours of missing hours' do
        user1 = create(:user)

        create(:time_off, user: user1, starts_at: start_date + 8.hours, ends_at: start_date + 13.hours)

        create(:time_entry, statement_of_work: sow, date: start_date + 2.days, user: user1, hours: 3)
        create(:time_entry, statement_of_work: sow, date: start_date + 3.days, user: user1, hours: 3)
        create(:time_entry, statement_of_work: sow, date: start_date + 4.days, user: user1, hours: 8)
        create(:time_entry, statement_of_work: sow, date: start_date + 5.days, user: user1, hours: 8)
        create(:time_entry, statement_of_work: sow, date: start_date + 5.days, user: user1, hours: 8)

        requirement1 = create(:requirement, statement_of_work: sow, coverage: 1, start_date:,
                                            end_date:)

        create(:assignment, requirement: requirement1, user: user1, coverage: 1, start_date:,
                            end_date:)

        data = Analytics::TimeEntriesAnalytics.new(project, start_date, end_date).data
        data_json = data.to_json
        expected_response_json = {
          labels: [user1.name],
          datasets: [
            {
              label: 'Worked',
              data: [30.0]
            },
            {
              label: 'Paid time off',
              data: [5.0]
            },
            {
              label: 'Over delivered',
              data: [0]
            },
            {
              label: 'Sick leave',
              data: [0]
            },
            {
              label: 'Missing',
              data: [5.0]
            },
            {
              label: 'Errands',
              data: [0]
            },
            {
              label: 'Expected Hours',
              data: [40.0]
            }
          ]
        }.to_json
        expect(data_json).to eql(expected_response_json)
      end
    end

    context 'when the user has 5 hours of PTO during the period and 8 hours of sick leave' do
      it 'returns 5 hours of pto and 8 hours of sick leave' do
        user1 = create(:user)

        create(:time_off, :vacation, user: user1, starts_at: start_date + 8.hours,
                                     ends_at: start_date + 13.hours)
        create(:time_off, :sick_leave, user: user1, starts_at: start_date + 1.day,
                                       ends_at: (start_date + 2.days).beginning_of_day)

        create(:time_entry, statement_of_work: sow, date: start_date + 2.days, user: user1, hours: 3)
        create(:time_entry, statement_of_work: sow, date: start_date + 3.days, user: user1, hours: 3)
        create(:time_entry, statement_of_work: sow, date: start_date + 4.days, user: user1, hours: 8)
        create(:time_entry, statement_of_work: sow, date: start_date + 5.days, user: user1, hours: 8)
        create(:time_entry, statement_of_work: sow, date: start_date + 5.days, user: user1, hours: 8)

        requirement1 = create(:requirement, statement_of_work: sow, coverage: 1, start_date:,
                                            end_date:)

        create(:assignment, requirement: requirement1, user: user1, coverage: 1, start_date:,
                            end_date:)

        data = Analytics::TimeEntriesAnalytics.new(project, start_date, end_date).data
        data_json = data.to_json
        expected_response_json = {
          labels: [user1.name],
          datasets: [
            {
              label: 'Worked',
              data: [30.0]
            },
            {
              label: 'Paid time off',
              data: [5.0]
            },
            {
              label: 'Over delivered',
              data: [0]
            },
            {
              label: 'Sick leave',
              data: [8.0]
            },
            {
              label: 'Missing',
              data: [0]
            },
            {
              label: 'Errands',
              data: [0]
            },
            {
              label: 'Expected Hours',
              data: [40.0]
            }
          ]
        }.to_json
        expect(data_json).to eql(expected_response_json)
      end
    end

    context 'when the user overworked by 8 hours' do
      it 'returns 8 hours in the overwork' do
        user1 = create(:user)

        create(:time_entry, statement_of_work: sow, date: start_date + 2.days, user: user1, hours: 10)
        create(:time_entry, statement_of_work: sow, date: start_date + 3.days, user: user1, hours: 9)
        create(:time_entry, statement_of_work: sow, date: start_date + 4.days, user: user1, hours: 9)
        create(:time_entry, statement_of_work: sow, date: start_date + 5.days, user: user1, hours: 8)
        create(:time_entry, statement_of_work: sow, date: start_date + 6.days, user: user1, hours: 12)

        requirement1 = create(:requirement, statement_of_work: sow, coverage: 1, start_date:,
                                            end_date:)

        create(:assignment, requirement: requirement1, user: user1, coverage: 1, start_date:,
                            end_date:)

        data = Analytics::TimeEntriesAnalytics.new(project, start_date, end_date).data
        data_json = data.to_json
        expected_response_json = {
          labels: [user1.name],
          datasets: [
            {
              label: 'Worked',
              data: [40.0]
            },
            {
              label: 'Paid time off',
              data: [0]
            },
            {
              label: 'Over delivered',
              data: [8.0]
            },
            {
              label: 'Sick leave',
              data: [0]
            },
            {
              label: 'Missing',
              data: [0]
            },
            {
              label: 'Errands',
              data: [0]
            },
            {
              label: 'Expected Hours',
              data: [40.0]
            }
          ]
        }.to_json
        expect(data_json).to eql(expected_response_json)
      end
    end
  end
end
