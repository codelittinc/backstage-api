# frozen_string_literal: true

class RemoveLimitByDeliveryScheduleFromSow < ActiveRecord::Migration[7.0]
  def change
    remove_column :statement_of_works, :limit_by_delivery_schedule, :boolean
  end
end
