# frozen_string_literal: true

class ChangeHoursAmountToFloatInTimeAndMaterialsAtCostContractModels < ActiveRecord::Migration[7.0]
  def change
    remove_column :time_and_materials_at_cost_contract_models, :hours_amount, :boolean
    add_column :time_and_materials_at_cost_contract_models, :hours_amount, :float
  end
end
