# frozen_string_literal: true

# == Schema Information
#
# Table name: statement_of_works
#
#  id                         :bigint           not null, primary key
#  end_date                   :datetime
#  hour_delivery_schedule     :string
#  hourly_revenue             :float
#  limit_by_delivery_schedule :boolean          default(TRUE), not null
#  model                      :string
#  name                       :string
#  start_date                 :datetime
#  total_hours                :float
#  total_revenue              :float
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  project_id                 :bigint           not null
#
# Indexes
#
#  index_statement_of_works_on_project_id  (project_id)
#
# Foreign Keys
#
#  fk_rails_...  (project_id => projects.id)
#
FactoryBot.define do
  factory :statement_of_work do
    project
    start_date { Time.zone.today - 6.months }
    end_date { Time.zone.today + 6.months }
    name { FFaker::Lorem.sentence }

    trait :with_maintenance do
      model { 'maintenance' }
      hourly_revenue { 100 }
      total_hours { 120 }
      total_revenue { 12_000 }
      hour_delivery_schedule { 'monthly' }
      limit_by_delivery_schedule { true }
    end

    trait :with_time_and_materials do
      model { 'time_and_materials' }
      hourly_revenue { 100 }
      total_hours { 120 }
      total_revenue { 12_000 }
      hour_delivery_schedule { 'contract_period' }
      limit_by_delivery_schedule { true }
    end

    trait :with_fixed_bid do
      model { 'time_and_materials' }
      hourly_revenue { nil }
      total_hours { nil }
      total_revenue { 12_000 }
      hour_delivery_schedule { 'contract_period' }
      limit_by_delivery_schedule { false }
    end
  end
end
