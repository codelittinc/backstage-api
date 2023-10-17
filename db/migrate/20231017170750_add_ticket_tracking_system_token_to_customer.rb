# frozen_string_literal: true

class AddTicketTrackingSystemTokenToCustomer < ActiveRecord::Migration[7.0]
  def change
    add_column :customers, :ticket_tracking_system_token, :string
  end
end
