# frozen_string_literal: true

class AddSprintToIssues < ActiveRecord::Migration[7.0]
  def change
    add_column :issues, :sprint, :string
  end
end
