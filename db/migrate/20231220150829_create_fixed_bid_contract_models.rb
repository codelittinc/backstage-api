# frozen_string_literal: true

class CreateFixedBidContractModels < ActiveRecord::Migration[7.0]
  def change
    create_table :fixed_bid_contract_models do |t|
      t.boolean :fixed_timeline, default: false, null: false

      t.timestamps
    end
  end
end
