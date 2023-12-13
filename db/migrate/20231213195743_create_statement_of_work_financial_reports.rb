# frozen_string_literal: true

class CreateStatementOfWorkFinancialReports < ActiveRecord::Migration[7.0]
  def change
    create_table :statement_of_work_financial_reports do |t|
      # Remove index: true from here
      t.integer :statement_of_work_id, null: false
      t.datetime :start_date
      t.datetime :end_date
      t.float :total_executed_income

      t.timestamps
    end

    # Add the index after the create_table block
    # You can provide a custom shorter name if needed
    add_index :statement_of_work_financial_reports, :statement_of_work_id, name: 'index_sow_financial_reports_on_sow_id'
  end
end
