class RemoveFieldsFromStatementOfWorks < ActiveRecord::Migration[7.0]
  def change
    remove_column :statement_of_works, :allow_revenue_overflow, :boolean
    remove_column :statement_of_works, :hour_delivery_schedule, :string
    remove_column :statement_of_works, :hourly_revenue, :float
    remove_column :statement_of_works, :limit_by_delivery_schedule, :boolean
    remove_column :statement_of_works, :model, :string
    remove_column :statement_of_works, :total_hours, :float
    rename_column :statement_of_works, :total_revenue, :contract_size
  end
end
