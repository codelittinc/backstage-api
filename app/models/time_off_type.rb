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
  validates :name, presence: true
end
