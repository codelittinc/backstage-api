# frozen_string_literal: true

class ChangeDateToDateTimeInAssignments < ActiveRecord::Migration[7.0]
  def up
    change_column :assignments, :end_date, :datetime
    change_column :assignments, :start_date, :datetime
  end

  def down
    change_column :assignments, :end_date, :date
    change_column :assignments, :start_date, :date
  end
end
