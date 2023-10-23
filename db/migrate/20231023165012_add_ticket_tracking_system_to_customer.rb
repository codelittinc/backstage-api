# frozen_string_literal: true

class AddTicketTrackingSystemToCustomer < ActiveRecord::Migration[7.0]
  def change
    add_column :customers, :ticket_tracking_system, :string
  end
end
