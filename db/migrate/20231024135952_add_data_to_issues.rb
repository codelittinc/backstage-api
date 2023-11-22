# frozen_string_literal: true

class AddDataToIssues < ActiveRecord::Migration[7.0]
  def change
    add_column :issues, :issue_id, :string
    add_column :issues, :issue_type, :string
    add_column :issues, :title, :string
    # rubocop:enable Rails/BulkChangeTable
  end
end
