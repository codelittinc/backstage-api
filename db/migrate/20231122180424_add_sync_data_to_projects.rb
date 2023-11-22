# frozen_string_literal: true

class AddSyncDataToProjects < ActiveRecord::Migration[7.0]
  def change
    add_column :projects, :sync_ticket_tracking_system, :boolean, default: false, null: false
    add_column :projects, :sync_source_control, :boolean, default: false, null: false
  end
end
