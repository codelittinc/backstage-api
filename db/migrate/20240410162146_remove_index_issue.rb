# frozen_string_literal: true

class RemoveIndexIssue < ActiveRecord::Migration[7.0]
  def change
    remove_index :issues, column: :user_id, name: :index_issues_on_user_id
    remove_foreign_key :issues, column: :user_id
    change_column :issues, :user_id, :bigint, null: true
  end
end
