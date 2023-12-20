# frozen_string_literal: true

class CreateTimeAndMaterialsContractModels < ActiveRecord::Migration[7.0]
  def change
    create_table :time_and_materials_contract_models do |t|
      t.float :hourly_price
      t.float :hours_amount
      t.boolean :allow_overflow, default: false, null: false
      t.string :limit_by

      t.timestamps
    end
  end
end
