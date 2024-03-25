# frozen_string_literal: true

class AddReportedOnToIssues < ActiveRecord::Migration[7.0]
  def change
    add_column :issues, :reported_at, :datetime
  end
end
