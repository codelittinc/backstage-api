# frozen_string_literal: true

class CreateIssues < ActiveRecord::Migration[7.0]
  def change
    create_table :issues do |t|
      t.float :effort
      t.references :user, null: false, foreign_key: true
      t.string :state
      t.datetime :closed_date

      t.timestamps
    end
  end
end
