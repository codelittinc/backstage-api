# frozen_string_literal: true

class RemoveTotalHoursFromStatementOfWork < ActiveRecord::Migration[7.0]
  def change
    remove_column :statement_of_works, :total_hours, :float
  end
end
