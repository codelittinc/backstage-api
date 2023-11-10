# frozen_string_literal: true

# == Schema Information
#
# Table name: assignments
#
#  id             :bigint           not null, primary key
#  coverage       :float
#  end_date       :date
#  start_date     :date
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  requirement_id :bigint           not null
#  user_id        :bigint           not null
#
# Indexes
#
#  index_assignments_on_requirement_id  (requirement_id)
#  index_assignments_on_user_id         (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (requirement_id => requirements.id)
#  fk_rails_...  (user_id => users.id)
#
class Assignment < ApplicationRecord
  belongs_to :requirement
  belongs_to :user

  validates :coverage, presence: true

  scope :active_in_period, ->(start_date, end_date) { where('start_date <= ? AND end_date >= ?', end_date, start_date) }
end
