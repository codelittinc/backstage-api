# frozen_string_literal: true

class CreateTimeAndMaterialsAtCostContractModels < ActiveRecord::Migration[7.0]
  def change
    create_table :time_and_materials_at_cost_contract_models do |t|
      t.boolean :hours_amount, default: false, null: false
      t.boolean :allow_overflow, default: false, null: false
      t.string :limit_by
      t.float :management_factor

      t.timestamps
    end
  end
end
