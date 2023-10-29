# frozen_string_literal: true

class CreateTimeEntries < ActiveRecord::Migration[7.0]
  def change
    create_table :time_entries do |t|
      t.date :date
      t.float :hours
      t.references :user, null: false, foreign_key: true
      t.references :statement_of_work, null: false, foreign_key: true

      t.timestamps
    end
  end
end
