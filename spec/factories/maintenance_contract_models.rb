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
    delivery_period { 'MyString' }
    expected_hours_per_period { 1.5 }
    revenue_per_period { 1.5 }
    expected_revenue { 1.5 }
    accumulate_hours { false }
    charge_upfront { false }
    hourly_cost { 1.5 }
    statement_of_work_id { 1 }
  end
end
