# frozen_string_literal: true

class RemoveHourlyDeliveryScheduleFromStatementOfWork < ActiveRecord::Migration[7.0]
  def change
    remove_column :statement_of_works, :hour_delivery_schedule, :string
  end
end
