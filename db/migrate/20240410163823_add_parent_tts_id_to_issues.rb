# frozen_string_literal: true

class AddParentTtsIdToIssues < ActiveRecord::Migration[7.0]
  def change
    add_column :issues, :parent_tts_id, :string
  end
end
