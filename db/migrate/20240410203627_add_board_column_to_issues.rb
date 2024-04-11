# frozen_string_literal: true

class AddBoardColumnToIssues < ActiveRecord::Migration[7.0]
  def change
    add_column :issues, :board_column, :string
  end
end
