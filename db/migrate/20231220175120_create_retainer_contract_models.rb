# frozen_string_literal: true

class CreateRetainerContractModels < ActiveRecord::Migration[7.0]
  def change
    create_table :retainer_contract_models do |t|
      t.boolean :charge_upfront, default: false, null: false
      t.float :revenue_per_period

      t.timestamps
    end
  end
end
