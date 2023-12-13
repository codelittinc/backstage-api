# frozen_string_literal: true

class AddAllowRevenueOverflowToStatementOfWork < ActiveRecord::Migration[7.0]
  def change
    add_column :statement_of_works, :allow_revenue_overflow, :boolean, default: false, null: false
  end
end
