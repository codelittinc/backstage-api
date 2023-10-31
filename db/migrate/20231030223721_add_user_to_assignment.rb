# frozen_string_literal: true

class AddUserToAssignment < ActiveRecord::Migration[7.0]
  def change
    # rubocop:disable Rails/NotNullColumn
    add_reference :assignments, :user, null: false, foreign_key: true
    # rubocop:enable Rails/NotNullColumn
  end
end
