# frozen_string_literal: true

class AddDisplayInfoToProjects < ActiveRecord::Migration[7.0]
  def change
    add_column :projects, :display_tasks_metrics, :boolean, default: false, null: false
    add_column :projects, :display_code_metrics, :boolean, default: false, null: false
  end
end
