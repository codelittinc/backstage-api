# frozen_string_literal: true

class AddAttributesToProjects < ActiveRecord::Migration[7.0]
  def change
    change_table :projects, bulk: true do |t|
      t.column :billable, :boolean, default: true, null: false
      t.column :slack_channel, :string
      t.column :start_date, :date
      t.column :end_date, :date
    end
  end
end
