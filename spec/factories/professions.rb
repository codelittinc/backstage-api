# frozen_string_literal: true

FactoryBot.define do
  factory :profession do
    name { FFaker::Job.title }
  end
end
