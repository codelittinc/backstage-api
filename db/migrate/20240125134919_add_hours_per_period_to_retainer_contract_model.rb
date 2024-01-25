# frozen_string_literal: true

class AddHoursPerPeriodToRetainerContractModel < ActiveRecord::Migration[7.0]
  def change
    add_column :retainer_contract_models, :expected_hours_per_period, :float, default: 0
  end
end
