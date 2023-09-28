# frozen_string_literal: true

class AddFieldsToCustomer < ActiveRecord::Migration[7.0]
  def change
    change_table :customers, bulk: true do |t|
      t.string :notifications_token
      t.string :source_control_token
    end
  end
end
