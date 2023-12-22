# frozen_string_literal: true

# == Schema Information
#
# Table name: time_and_materials_at_cost_contract_models
#
#  id                :bigint           not null, primary key
#  allow_overflow    :boolean          default(FALSE), not null
#  hours_amount      :float
#  limit_by          :string
#  management_factor :float
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
require 'rails_helper'

RSpec.describe TimeAndMaterialsAtCostContractModel, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
