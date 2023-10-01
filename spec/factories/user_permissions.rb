# frozen_string_literal: true

FactoryBot.define do
  factory :user_permission do
    user { nil }
    permission { FactoryBot.create(:permission) }
  end
end
