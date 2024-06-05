# frozen_string_literal: true

class CreateProjectAuths < ActiveRecord::Migration[7.0]
  def change
    create_table :project_auths do |t|
      t.references :project, null: false, foreign_key: true
      t.string :key

      t.timestamps
    end
  end
end
