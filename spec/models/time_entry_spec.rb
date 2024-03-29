# frozen_string_literal: true

# == Schema Information
#
# Table name: time_entries
#
#  id                   :bigint           not null, primary key
#  date                 :date
#  hours                :float
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  statement_of_work_id :bigint           not null
#  user_id              :bigint           not null
#
# Indexes
#
#  index_time_entries_on_date_and_user_id_and_sow_id  (date,user_id,statement_of_work_id) UNIQUE
#  index_time_entries_on_statement_of_work_id         (statement_of_work_id)
#  index_time_entries_on_user_id                      (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (statement_of_work_id => statement_of_works.id)
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe TimeEntry, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:hours) }
    it { should validate_presence_of(:date) }
  end

  describe 'associations' do
    it { should belong_to(:statement_of_work) }
    it { should belong_to(:user) }
  end

  context 'assignments' do
    it 'is valid if there is an assignment active for the sow' do
      start_date = Time.zone.today - 1.day
      end_date = Time.zone.today + 1.day

      assignment = create(:assignment, start_date:, end_date:)
      sow_id = assignment.requirement.statement_of_work.id
      time_entry = TimeEntry.new(date: Time.zone.today, hours: 8, statement_of_work_id: sow_id, user_id: assignment.user.id)

      expect(time_entry).to be_valid
    end

    it 'is invalid if there is no assignment active for the sow' do
      user = create(:user)
      sow = create(:statement_of_work)
      time_entry = TimeEntry.new(date: Time.zone.today, hours: 8, statement_of_work_id: sow.id, user_id: user.id)

      expect(time_entry).not_to be_valid
    end
  end
end
