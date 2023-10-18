# frozen_string_literal: true

class AddProjectsToIssue < ActiveRecord::Migration[7.0]
  def change
    add_reference :issues, :project, null: false, foreign_key: true # rubocop:disable Rails/NotNullColumn
  end
end
