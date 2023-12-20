# frozen_string_literal: true

class CreateMaintenanceContractModels < ActiveRecord::Migration[7.0]
  def change
    create_table :maintenance_contract_models do |t|
      t.string :delivery_period
      t.float :expected_hours_per_period
      t.float :revenue_per_period
      t.boolean :accumulate_hours, default: false, null: false
      t.boolean :charge_upfront, default: false, null: false
      t.float :hourly_cost

      t.timestamps
    end
  end
end
