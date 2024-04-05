# frozen_string_literal: true

class AddBugToIssue < ActiveRecord::Migration[7.0]
  def change
    add_column :issues, :bug, :boolean, default: false, null: false
  end
end
