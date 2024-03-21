# frozen_string_literal: true

class ChangeDateToDateTimeInRequirements < ActiveRecord::Migration[7.0]
  def up
    change_column :requirements, :end_date, :datetime
    change_column :requirements, :start_date, :datetime
  end

  def down
    change_column :requirements, :end_date, :date
    change_column :requirements, :start_date, :date
  end
end
