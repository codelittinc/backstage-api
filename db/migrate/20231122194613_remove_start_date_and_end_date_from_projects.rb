# frozen_string_literal: true

class RemoveStartDateAndEndDateFromProjects < ActiveRecord::Migration[7.0]
  def change
    remove_column :projects, :start_date, :date
    remove_column :projects, :end_date, :date
  end
end
