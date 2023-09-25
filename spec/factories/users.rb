# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { "#{FFaker::Name.first_name}.#{FFaker::Name.last_name}@#{ENV.fetch('VALID_USER_DOMAIN', nil)}" }
    first_name { FFaker::Name.first_name }
    last_name { FFaker::Name.last_name }
    google_id { rand(1e9..1e10).to_i.to_s }

    association :profession
  end
end
