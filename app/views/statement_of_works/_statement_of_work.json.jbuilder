# frozen_string_literal: true

json.extract! statement_of_work, :id, :model, :hourly_revenue, :total_revenue, :total_hours, :hour_delivery_schedule,
              :start_date, :end_date, :project_id, :created_at, :updated_at, :name
