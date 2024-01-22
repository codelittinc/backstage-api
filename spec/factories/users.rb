# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id            :bigint           not null, primary key
#  active        :boolean          default(TRUE), not null
#  contract_type :string
#  country       :string
#  email         :string
#  first_name    :string
#  image_url     :string
#  internal      :boolean          default(TRUE), not null
#  last_name     :string
#  seniority     :string
#  slug          :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  google_id     :string
#  profession_id :bigint
#
# Indexes
#
#  index_users_on_email          (email) UNIQUE
#  index_users_on_google_id      (google_id) UNIQUE
#  index_users_on_profession_id  (profession_id)
#  index_users_on_slug           (slug) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (profession_id => professions.id)
#
FactoryBot.define do
  factory :user do
    email { "#{FFaker::Name.first_name}@codelitt.com" }
    first_name { FFaker::Name.first_name }
    last_name { FFaker::Name.last_name }
    google_id { rand(1e9..1e10).to_i.to_s }
    image_url { FFaker::Avatar.image }
    contract_type { FFaker::Lorem.word }
    seniority { %w[Intern Junior Midlevel Senior].sample }
    active { [true, false].sample }
    internal { true }

    profession

    after(:create) do |user|
      create(:salary, user:)
    end
  end
end
