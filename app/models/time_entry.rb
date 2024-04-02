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
class TimeEntry < ApplicationRecord
  belongs_to :user
  belongs_to :statement_of_work

  validates :hours, presence: true
  validates :date, presence: true

  validates :date, uniqueness: { scope: %i[user_id statement_of_work_id] }
  #  validate :assignment_must_exist_in_period

  scope :active_in_period, ->(start_date, end_date) { where('date <= ? AND date >= ?', end_date, start_date) }

  #  def assignment_must_exist_in_period
  #    assignment_exists = Assignment.joins(:requirement)
  #                                  .where(user_id:)
  #                                  .where(requirements: { statement_of_work_id: })
  #                                  .exists?(['? >= assignments.start_date AND ? <= assignments.end_date', date, date])
  #
  #    # If not, add an error.
  #    return if assignment_exists
  #
  #    errors.add(:base,
  #               "There is no valid assignment for the user
  #                and statement of work in this period: #{user.name}
  #                 date:#{date} for the SOW: #{statement_of_work.name}
  #                  in the project #{statement_of_work.project.name}")
  #  end
end
