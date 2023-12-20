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
require 'rails_helper'

RSpec.describe FixedBidContractModel, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
