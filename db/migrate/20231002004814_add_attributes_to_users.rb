# frozen_string_literal: true

class AddAttributesToUsers < ActiveRecord::Migration[7.0]
  def change
    change_table :users, bulk: true do |t|
      t.column :contract_type, :string
      t.column :seniority, :string
      t.column :active, :boolean, default: true, null: false
    end
  end
end
