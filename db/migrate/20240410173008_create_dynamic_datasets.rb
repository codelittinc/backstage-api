# frozen_string_literal: true

class CreateDynamicDatasets < ActiveRecord::Migration[7.0]
  def change
    create_table :dynamic_datasets do |t|
      t.string :name
      t.string :code
      t.references :project, null: false, foreign_key: true

      t.timestamps
    end
  end
end