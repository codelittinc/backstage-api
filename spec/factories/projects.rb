# frozen_string_literal: true

FactoryBot.define do
  factory :project do
    name { 'MyString' }
    customer { nil }
  end
end
