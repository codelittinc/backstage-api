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
class TimeEntry < ApplicationRecord
  belongs_to :user
  belongs_to :statement_of_work

  validates :hours, presence: true
  validates :date, presence: true
end
