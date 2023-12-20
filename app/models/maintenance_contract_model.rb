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
class MaintenanceContractModel < ApplicationRecord
  has_one :statement_of_work, as: :contract_model, dependent: :destroy
end
