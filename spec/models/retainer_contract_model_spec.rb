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
require 'rails_helper'

RSpec.describe RetainerContractModel, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
