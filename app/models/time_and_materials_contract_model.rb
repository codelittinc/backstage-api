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
class TimeAndMaterialsContractModel < ApplicationRecord
  has_one :statement_of_work, as: :contract_model, dependent: :destroy

  validates :limit_by, inclusion: { in: %w[hours contract_size] }
end
