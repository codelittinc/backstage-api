# frozen_string_literal: true

# == Schema Information
#
# Table name: statement_of_works
#
#  id                  :bigint           not null, primary key
#  contract_model_type :string
#  contract_size       :float
#  end_date            :datetime
#  name                :string
#  start_date          :datetime
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
    contract_size { 1000 }

    trait :with_maintenance do
      after(:build) do |sow|
        sow.contract_model = build(:maintenance_contract_model)
      end
    end

    trait :with_time_and_materials do
      after(:build) do |sow|
        sow.contract_model = build(:time_and_materials_contract_model, statement_of_work: sow)
      end
    end

    trait :with_fixed_bid do
      after(:build) do |sow|
        sow.contract_model = build(:fixed_bid_contract_model, statement_of_work: sow)
      end
    end

    trait :with_time_and_materials_at_cost do
      after(:build) do |sow|
        sow.contract_model = build(:time_and_materials_at_cost_contract_model, statement_of_work: sow)
      end
    end
  end
end
