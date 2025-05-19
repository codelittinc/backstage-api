# frozen_string_literal: true

class AddFeedbackToAssignments < ActiveRecord::Migration[7.0]
  def change
    add_column :assignments, :feedback, :text
  end
end
