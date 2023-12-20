# frozen_string_literal: true

# == Schema Information
#
# Table name: time_and_materials_at_cost_contract_models
#
#  id                :bigint           not null, primary key
#  allow_overflow    :boolean
#  hours_amount      :float
#  limit_by          :string
#  management_factor :float
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
FactoryBot.define do
  factory :time_and_materials_at_cost_contract_model do
    hours_amount { false }
    allow_overflow { false }
    limit_by { 'MyString' }
    management_factor { 1.5 }
  end
end
