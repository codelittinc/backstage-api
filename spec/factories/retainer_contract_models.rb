# frozen_string_literal: true

# == Schema Information
#
# Table name: retainer_contract_models
#
#  id                        :bigint           not null, primary key
#  charge_upfront            :boolean          default(FALSE), not null
#  expected_hours_per_period :float            default(0.0)
#  revenue_per_period        :float
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#
FactoryBot.define do
  factory :retainer_contract_model do
    charge_upfront { false }
    revenue_per_period { 1.5 }
  end
end
