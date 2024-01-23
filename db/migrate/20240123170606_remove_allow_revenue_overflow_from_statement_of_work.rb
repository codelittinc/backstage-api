# frozen_string_literal: true

class RemoveAllowRevenueOverflowFromStatementOfWork < ActiveRecord::Migration[7.0]
  def change
    remove_column :statement_of_works, :allow_revenue_overflow, :boolean
  end
end
