# frozen_string_literal: true

class AddSprintsDataToIssues < ActiveRecord::Migration[7.0]
  def change
    add_column :issues, :sprint_start_date, :datetime
    add_column :issues, :sprint_end_date, :datetime
  end
end
