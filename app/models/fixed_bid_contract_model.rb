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
class FixedBidContractModel < ApplicationRecord
  has_one :statement_of_work, as: :contract_model, dependent: :destroy
end
