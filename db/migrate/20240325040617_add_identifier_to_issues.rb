# frozen_string_literal: true

class AddIdentifierToIssues < ActiveRecord::Migration[7.0]
  def change
    add_column :issues, :tts_id, :string
  end
end
