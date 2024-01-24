# frozen_string_literal: true

# == Schema Information
#
# Table name: maintenance_contract_models
#
#  id                        :bigint           not null, primary key
#  accumulate_hours          :boolean          default(FALSE), not null
#  charge_upfront            :boolean          default(FALSE), not null
#  delivery_period           :string
#  expected_hours_per_period :float
#  hourly_cost               :float
#  revenue_per_period        :float
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#
FactoryBot.define do
  factory :maintenance_contract_model do
    accumulate_hours { false }
    charge_upfront { false }
    delivery_period { 'monthly' }
    expected_hours_per_period { 120 }
    revenue_per_period { 12_000 }
    hourly_cost { 100 }
  end
end
