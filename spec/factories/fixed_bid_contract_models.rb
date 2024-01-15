# frozen_string_literal: true

# == Schema Information
#
# Table name: fixed_bid_contract_models
#
#  id             :bigint           not null, primary key
#  fixed_timeline :boolean          default(FALSE), not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
FactoryBot.define do
  factory :fixed_bid_contract_model do
    fixed_timeline { false }
    statement_of_work_id { 1 }
  end
end
