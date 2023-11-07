# frozen_string_literal: true

# == Schema Information
#
# Table name: time_off_types
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class TimeOffType < ApplicationRecord
  VACATION_TYPE = 'vacation'
  SICK_LEAVE_TYPE = 'sick leave'
  ERRAND_TYPE = 'errand'

  validates :name, presence: true, inclusion: { in: [VACATION_TYPE, SICK_LEAVE_TYPE, ERRAND_TYPE] }
end
