# frozen_string_literal: true

# == Schema Information
#
# Table name: time_and_materials_contract_models
#
#  id             :bigint           not null, primary key
#  allow_overflow :boolean          default(FALSE), not null
#  hourly_price   :float
#  hours_amount   :float
#  limit_by       :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
FactoryBot.define do
  factory :time_and_materials_contract_model do
    hourly_price { 100 }
    hours_amount { 120 }
    allow_hour_overflow { false }
    expected_revenue { 12_000 }
  end
end
