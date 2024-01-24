# frozen_string_literal: true

class RemoveHourlyRevenueFromStatementOfWork < ActiveRecord::Migration[7.0]
  def change
    remove_column :statement_of_works, :hourly_revenue, :float
  end
end
