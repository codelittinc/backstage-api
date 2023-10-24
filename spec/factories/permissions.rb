# frozen_string_literal: true

# == Schema Information
#
# Table name: permissions
#
#  id         :bigint           not null, primary key
#  target     :string
#  ability    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :permission do
    target { FFaker::Lorem.word }
    ability { FFaker::Lorem.word }
  end
end
