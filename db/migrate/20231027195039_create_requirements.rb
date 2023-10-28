# frozen_string_literal: true

class CreateRequirements < ActiveRecord::Migration[7.0]
  def change
    create_table :requirements do |t|
      t.references :profession, null: false, foreign_key: true
      t.references :statement_of_work, null: false, foreign_key: true
      t.float :coverage

      t.timestamps
    end
  end
end
