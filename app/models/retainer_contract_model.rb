# frozen_string_literal: true

# == Schema Information
#
# Table name: retainer_contract_models
#
#  id                 :bigint           not null, primary key
#  charge_upfront     :boolean          default(FALSE), not null
#  revenue_per_period :float
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
class RetainerContractModel < ApplicationRecord
end
