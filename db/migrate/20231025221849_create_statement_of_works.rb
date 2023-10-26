# frozen_string_literal: true

class CreateStatementOfWorks < ActiveRecord::Migration[7.0]
  def change
    create_table :statement_of_works do |t|
      t.string :model
      t.float :hourly_revenue
      t.float :total_revenue
      t.float :total_hours
      t.string :hour_delivery_schedule
      t.boolean :limit_by_delivery_schedule, default: true, null: false
      t.datetime :start_date
      t.datetime :end_date
      t.references :project, null: false, foreign_key: true

      t.timestamps
    end
  end
end
