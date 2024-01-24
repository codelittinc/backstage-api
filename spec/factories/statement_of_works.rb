# frozen_string_literal: true

# == Schema Information
#
# Table name: statement_of_works
#
#  id                  :bigint           not null, primary key
#  contract_model_type :string
#  end_date            :datetime
#  model               :string
#  name                :string
#  start_date          :datetime
#  total_revenue       :float
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  contract_model_id   :integer
#  project_id          :bigint           not null
#
# Indexes
#
#  index_sow_on_contract_model             (contract_model_id,contract_model_type)
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
      total_revenue { 12_000 }
    end

    trait :with_time_and_materials do
      model { 'time_and_materials' }
      total_revenue { 12_000 }
    end

    trait :with_fixed_bid do
      model { 'time_and_materials' }
      total_revenue { 12_000 }
    end
  end
end
