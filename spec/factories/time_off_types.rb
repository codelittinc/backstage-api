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
FactoryBot.define do
  factory :time_off_type do
    name { 'paid time off' }
  end
end
