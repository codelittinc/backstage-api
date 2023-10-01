# frozen_string_literal: true

FactoryBot.define do
  factory :permission do
    target { Faker::Lorem.word }
    ability { Faker::Lorem.word }
  end
end
