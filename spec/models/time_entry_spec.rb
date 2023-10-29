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
#  index_time_entries_on_statement_of_work_id  (statement_of_work_id)
#  index_time_entries_on_user_id               (user_id)
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
end
