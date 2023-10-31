# frozen_string_literal: true

class AddStartDateAndEndDateToAssignment < ActiveRecord::Migration[7.0]
  def change
    change_table :assignments, bulk: true do |t|
      t.date :start_date
      t.date :end_date
    end
  end
end
