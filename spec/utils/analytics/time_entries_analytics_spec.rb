# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Analytics::TimeEntriesAnalytics, type: :service do
  let(:sow) { FactoryBot.create(:statement_of_work, :with_fixed_bid) }
  let(:start_date) { Date.parse('2023/11/29') }
  let(:end_date) { start_date + 6.days }

  describe '#data' do
    context 'when the user puts the information for the entire period' do
      it 'returns the dataset for that SOW' do
        user1 = FactoryBot.create(:user)
        FactoryBot.create(:time_entry,
                          statement_of_work: sow, date: start_date + 1.day, user: user1, hours: 8)
        FactoryBot.create(:time_entry,
                          statement_of_work: sow, date: start_date + 2.days, user: user1, hours: 8)
        FactoryBot.create(:time_entry,
                          statement_of_work: sow, date: start_date + 3.days, user: user1, hours: 8)
        FactoryBot.create(:time_entry,
                          statement_of_work: sow, date: start_date + 4.days, user: user1, hours: 8)
        FactoryBot.create(:time_entry,
                          statement_of_work: sow, date: start_date + 5.days, user: user1, hours: 8)

        requirement1 = FactoryBot.create(:requirement, statement_of_work: sow, coverage: 1, start_date:,
                                                       end_date:)

        FactoryBot.create(:assignment, requirement: requirement1, user: user1, coverage: 1, start_date:,
                                       end_date:)

        data = Analytics::TimeEntriesAnalytics.new(sow, start_date, end_date).data
        data_json = data.to_json
        expected_response_json = {
          labels: [user1.name],
          datasets: [
            {
              label: 'Worked',
              data: [40.0]
            },
            {
              label: 'Missing',
              data: [0.0]
            },
            {
              label: 'Paid time off',
              data: [0]
            },
            {
              label: 'Sick leave',
              data: [0]
            },
            {
              label: 'Over delivered',
              data: [0.0]
            }
          ]
        }.to_json
        expect(data_json).to eql(expected_response_json)
      end
    end

    context 'when there are multiple users putting the information for the entire period' do
      it 'returns the dataset for that SOW' do
        user1 = FactoryBot.create(:user)
        user2 = FactoryBot.create(:user)
        user3 = FactoryBot.create(:user)

        # user 1
        FactoryBot.create(:time_entry,
                          statement_of_work: sow, date: start_date + 1.day, user: user1, hours: 8)
        FactoryBot.create(:time_entry,
                          statement_of_work: sow, date: start_date + 2.days, user: user1, hours: 8)
        FactoryBot.create(:time_entry,
                          statement_of_work: sow, date: start_date + 3.days, user: user1, hours: 8)
        FactoryBot.create(:time_entry,
                          statement_of_work: sow, date: start_date + 4.days, user: user1, hours: 8)
        FactoryBot.create(:time_entry,
                          statement_of_work: sow, date: start_date + 5.days, user: user1, hours: 8)

        # user 2
        FactoryBot.create(:time_entry,
                          statement_of_work: sow, date: start_date + 1.day, user: user2, hours:  4)
        FactoryBot.create(:time_entry,
                          statement_of_work: sow, date: start_date + 2.days, user: user2, hours: 4)
        FactoryBot.create(:time_entry,
                          statement_of_work: sow, date: start_date + 3.days, user: user2, hours: 4)
        FactoryBot.create(:time_entry,
                          statement_of_work: sow, date: start_date + 4.days, user: user2, hours: 4)
        FactoryBot.create(:time_entry,
                          statement_of_work: sow, date: start_date + 5.days, user: user2, hours: 4)
        # user 3
        FactoryBot.create(:time_entry,
                          statement_of_work: sow, date: start_date + 1.day, user: user3, hours: 4)
        FactoryBot.create(:time_entry,
                          statement_of_work: sow, date: start_date + 2.days, user: user3, hours: 4)
        FactoryBot.create(:time_entry,
                          statement_of_work: sow, date: start_date + 3.days, user: user3, hours: 4)
        FactoryBot.create(:time_entry,
                          statement_of_work: sow, date: start_date + 4.days, user: user3, hours: 4)
        FactoryBot.create(:time_entry,
                          statement_of_work: sow, date: start_date + 5.days, user: user3, hours: 4)

        requirement1 = FactoryBot.create(:requirement, statement_of_work: sow, coverage: 1, start_date:,
                                                       end_date:)

        FactoryBot.create(:requirement, statement_of_work: sow, coverage: 1, start_date:,
                                        end_date:)

        FactoryBot.create(:assignment, requirement: requirement1, user: user1, coverage: 1, start_date:,
                                       end_date:)

        FactoryBot.create(:assignment, requirement: requirement1, user: user2, coverage: 0.5, start_date:,
                                       end_date:)
        FactoryBot.create(:assignment, requirement: requirement1, user: user3, coverage: 0.5, start_date:,
                                       end_date:)

        data = Analytics::TimeEntriesAnalytics.new(sow, start_date, end_date).data
        data_json = data.to_json
        expected_response_json = {
          labels: [user1.name, user2.name, user3.name],
          datasets: [
            {
              label: 'Worked',
              data: [40.0, 20.0, 20.0]
            },
            {
              label: 'Missing',
              data: [0.0, 0.0, 0.0]
            },
            {
              label: 'Paid time off',
              data: [0, 0, 0]
            },
            {
              label: 'Sick leave',
              data: [0, 0, 0]
            },
            {
              label: 'Over delivered',
              data: [0.0, 0.0, 0.0]
            }
          ]
        }.to_json
        expect(data_json).to eql(expected_response_json)
      end
    end

    context 'when the user does not add 5 hours for that period' do
      it 'returns 5 hours as missing' do
        user1 = FactoryBot.create(:user)

        FactoryBot.create(:time_entry, statement_of_work: sow, date: start_date + 1.day, user: user1, hours: 3)
        FactoryBot.create(:time_entry, statement_of_work: sow, date: start_date + 2.days, user: user1, hours: 8)
        FactoryBot.create(:time_entry, statement_of_work: sow, date: start_date + 3.days, user: user1, hours: 8)
        FactoryBot.create(:time_entry, statement_of_work: sow, date: start_date + 4.days, user: user1, hours: 8)
        FactoryBot.create(:time_entry, statement_of_work: sow, date: start_date + 5.days, user: user1, hours: 8)

        requirement1 = FactoryBot.create(:requirement, statement_of_work: sow, coverage: 1, start_date:,
                                                       end_date:)

        FactoryBot.create(:assignment, requirement: requirement1, user: user1, coverage: 1, start_date:,
                                       end_date:)

        data = Analytics::TimeEntriesAnalytics.new(sow, start_date, end_date).data
        data_json = data.to_json
        expected_response_json = {
          labels: [user1.name],
          datasets: [
            {
              label: 'Worked',
              data: [35.0]
            },
            {
              label: 'Missing',
              data: [5.0]
            },
            {
              label: 'Paid time off',
              data: [0]
            },
            {
              label: 'Sick leave',
              data: [0]
            },
            {
              label: 'Over delivered',
              data: [0]
            }
          ]
        }.to_json
        expect(data_json).to eql(expected_response_json)
      end
    end
    context 'when the user a full day of PTO during the period' do
      it 'returns 8 hours as paid time off' do
        user1 = FactoryBot.create(:user)

        FactoryBot.create(:time_off, :vacation, user: user1, starts_at: start_date, ends_at: start_date)

        FactoryBot.create(:time_entry, statement_of_work: sow, date: start_date + 2.days, user: user1, hours: 8)
        FactoryBot.create(:time_entry, statement_of_work: sow, date: start_date + 3.days, user: user1, hours: 8)
        FactoryBot.create(:time_entry, statement_of_work: sow, date: start_date + 4.days, user: user1, hours: 8)
        FactoryBot.create(:time_entry, statement_of_work: sow, date: start_date + 5.days, user: user1, hours: 8)

        requirement1 = FactoryBot.create(:requirement, statement_of_work: sow, coverage: 1, start_date:,
                                                       end_date:)

        FactoryBot.create(:assignment, requirement: requirement1, user: user1, coverage: 1, start_date:,
                                       end_date:)

        data = Analytics::TimeEntriesAnalytics.new(sow, start_date, end_date).data
        data_json = data.to_json
        expected_response_json = {
          labels: [user1.name],
          datasets: [
            {
              label: 'Worked',
              data: [32.0]
            },
            {
              label: 'Missing',
              data: [0.0]
            },
            {
              label: 'Paid time off',
              data: [8]
            },
            {
              label: 'Sick leave',
              data: [0]
            },
            {
              label: 'Over delivered',
              data: [0]
            }
          ]
        }.to_json
        expect(data_json).to eql(expected_response_json)
      end
    end

    context 'when the user has 2 hours of PTO during the period' do
      it 'returns 8 hours as paid time off' do
        user1 = FactoryBot.create(:user)

        FactoryBot.create(:time_off, user: user1, starts_at: start_date + 8.hours, ends_at: start_date + 10.hours)

        FactoryBot.create(:time_entry, statement_of_work: sow, date: start_date + 2.days, user: user1, hours: 6)
        FactoryBot.create(:time_entry, statement_of_work: sow, date: start_date + 3.days, user: user1, hours: 8)
        FactoryBot.create(:time_entry, statement_of_work: sow, date: start_date + 4.days, user: user1, hours: 8)
        FactoryBot.create(:time_entry, statement_of_work: sow, date: start_date + 5.days, user: user1, hours: 8)
        FactoryBot.create(:time_entry, statement_of_work: sow, date: start_date + 5.days, user: user1, hours: 8)

        requirement1 = FactoryBot.create(:requirement, statement_of_work: sow, coverage: 1, start_date:,
                                                       end_date:)

        FactoryBot.create(:assignment, requirement: requirement1, user: user1, coverage: 1, start_date:,
                                       end_date:)

        data = Analytics::TimeEntriesAnalytics.new(sow, start_date, end_date).data
        data_json = data.to_json
        expected_response_json = {
          labels: [user1.name],
          datasets: [
            {
              label: 'Worked',
              data: [38.0]
            },
            {
              label: 'Missing',
              data: [0.0]
            },
            {
              label: 'Paid time off',
              data: [2.0]
            },
            {
              label: 'Sick leave',
              data: [0]
            },
            {
              label: 'Over delivered',
              data: [0]
            }
          ]
        }.to_json
        expect(data_json).to eql(expected_response_json)
      end
    end

    context 'when the user has 5 hours of PTO during the period and is missing 5 hours' do
      it 'returns 5 hours of pto and 5 hours of missing hours' do
        user1 = FactoryBot.create(:user)

        FactoryBot.create(:time_off, user: user1, starts_at: start_date + 8.hours, ends_at: start_date + 13.hours)

        FactoryBot.create(:time_entry, statement_of_work: sow, date: start_date + 2.days, user: user1, hours: 3)
        FactoryBot.create(:time_entry, statement_of_work: sow, date: start_date + 3.days, user: user1, hours: 3)
        FactoryBot.create(:time_entry, statement_of_work: sow, date: start_date + 4.days, user: user1, hours: 8)
        FactoryBot.create(:time_entry, statement_of_work: sow, date: start_date + 5.days, user: user1, hours: 8)
        FactoryBot.create(:time_entry, statement_of_work: sow, date: start_date + 5.days, user: user1, hours: 8)

        requirement1 = FactoryBot.create(:requirement, statement_of_work: sow, coverage: 1, start_date:,
                                                       end_date:)

        FactoryBot.create(:assignment, requirement: requirement1, user: user1, coverage: 1, start_date:,
                                       end_date:)

        data = Analytics::TimeEntriesAnalytics.new(sow, start_date, end_date).data
        data_json = data.to_json
        expected_response_json = {
          labels: [user1.name],
          datasets: [
            {
              label: 'Worked',
              data: [30.0]
            },
            {
              label: 'Missing',
              data: [5.0]
            },
            {
              label: 'Paid time off',
              data: [5.0]
            },
            {
              label: 'Sick leave',
              data: [0]
            },
            {
              label: 'Over delivered',
              data: [0]
            }
          ]
        }.to_json
        expect(data_json).to eql(expected_response_json)
      end
    end

    context 'when the user has 5 hours of PTO during the period and 8 hours of sick leave' do
      it 'returns 5 hours of pto and 8 hours of sick leave' do
        user1 = FactoryBot.create(:user)

        FactoryBot.create(:time_off, :vacation, user: user1, starts_at: start_date + 8.hours,
                                                ends_at: start_date + 13.hours)
        FactoryBot.create(:time_off, :sick_leave, user: user1, starts_at: start_date + 1.day,
                                                  ends_at: start_date + 1.day)

        FactoryBot.create(:time_entry, statement_of_work: sow, date: start_date + 2.days, user: user1, hours: 3)
        FactoryBot.create(:time_entry, statement_of_work: sow, date: start_date + 3.days, user: user1, hours: 3)
        FactoryBot.create(:time_entry, statement_of_work: sow, date: start_date + 4.days, user: user1, hours: 8)
        FactoryBot.create(:time_entry, statement_of_work: sow, date: start_date + 5.days, user: user1, hours: 8)
        FactoryBot.create(:time_entry, statement_of_work: sow, date: start_date + 5.days, user: user1, hours: 8)

        requirement1 = FactoryBot.create(:requirement, statement_of_work: sow, coverage: 1, start_date:,
                                                       end_date:)

        FactoryBot.create(:assignment, requirement: requirement1, user: user1, coverage: 1, start_date:,
                                       end_date:)

        data = Analytics::TimeEntriesAnalytics.new(sow, start_date, end_date).data
        data_json = data.to_json
        expected_response_json = {
          labels: [user1.name],
          datasets: [
            {
              label: 'Worked',
              data: [30.0]
            },
            {
              label: 'Missing',
              data: [0]
            },
            {
              label: 'Paid time off',
              data: [5.0]
            },
            {
              label: 'Sick leave',
              data: [8]
            },
            {
              label: 'Over delivered',
              data: [0]
            }
          ]
        }.to_json
        expect(data_json).to eql(expected_response_json)
      end
    end

    context 'when the user overworked by 8 hours' do
      it 'returns 8 hours in the overwork' do
        user1 = FactoryBot.create(:user)

        FactoryBot.create(:time_entry, statement_of_work: sow, date: start_date + 2.days, user: user1, hours: 10)
        FactoryBot.create(:time_entry, statement_of_work: sow, date: start_date + 3.days, user: user1, hours: 9)
        FactoryBot.create(:time_entry, statement_of_work: sow, date: start_date + 4.days, user: user1, hours: 9)
        FactoryBot.create(:time_entry, statement_of_work: sow, date: start_date + 5.days, user: user1, hours: 8)
        FactoryBot.create(:time_entry, statement_of_work: sow, date: start_date + 6.days, user: user1, hours: 12)

        requirement1 = FactoryBot.create(:requirement, statement_of_work: sow, coverage: 1, start_date:,
                                                       end_date:)

        FactoryBot.create(:assignment, requirement: requirement1, user: user1, coverage: 1, start_date:,
                                       end_date:)

        data = Analytics::TimeEntriesAnalytics.new(sow, start_date, end_date).data
        data_json = data.to_json
        expected_response_json = {
          labels: [user1.name],
          datasets: [
            {
              label: 'Worked',
              data: [40.0]
            },
            {
              label: 'Missing',
              data: [0]
            },
            {
              label: 'Paid time off',
              data: [0]
            },
            {
              label: 'Sick leave',
              data: [0]
            },
            {
              label: 'Over delivered',
              data: [8.0]
            }
          ]
        }.to_json
        expect(data_json).to eql(expected_response_json)
      end
    end
  end
end

# const horizontalBarChartData = {
#   labels: [
#     "Rheniery",
#     "Carlos",
#     "Albo",
#     "Marla",
#     "Carlos",
#     "Gabriel",
#     "Rheniery",
#     "Carlos",
#     "Albo",
#     "Marla",
#     "Carlos",
#     "Gabriel",
#   ],
#   datasets: [
#     {
#       label: "Worked",
#       color: "success",
#       data: [15, 20, 12, 60, 20, 15, 15, 20, 12, 60, 20, 15],
#     },
#     {
#       label: "Missing",
#       color: "error",
#       data: [15, 20, 12, 60, 20, 15, 15, 20, 12, 60, 20, 15],
#     },
#     {
#       label: "Paid time off",
#       color: "info",
#       data: [15, 20, 12, 60, 20, 15, 15, 20, 12, 60, 20, 15],
#     },
#     {
#       label: "Sick leave",
#       color: "warning",
#       data: [15, 20, 12, 60, 20, 15, 15, 20, 12, 60, 20, 15],
#     },
#     {
#       label: "Over delivered",
#       color: "dark",
#       data: [15, 20, 12, 60, 20, 15, 15, 20, 12, 60, 20, 15],
#     },
#   ],
# };
