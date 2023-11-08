# frozen_string_literal: true

# == Schema Information
#
# Table name: time_offs
#
#  id               :bigint           not null, primary key
#  ends_at          :datetime
#  starts_at        :datetime
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  time_off_type_id :bigint           not null
#  user_id          :bigint           not null
#
# Indexes
#
#  index_time_offs_on_time_off_type_id  (time_off_type_id)
#  index_time_offs_on_user_id           (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (time_off_type_id => time_off_types.id)
#  fk_rails_...  (user_id => users.id)
#
class TimeOff < ApplicationRecord
  belongs_to :user
  belongs_to :time_off_type

  validates :starts_at, presence: true
  validates :ends_at, presence: true

  scope :active_in_period, ->(start_date, end_date) { where('starts_at <= ? AND ends_at >= ?', end_date, start_date) }
end
