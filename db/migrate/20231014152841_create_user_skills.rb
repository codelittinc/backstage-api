# frozen_string_literal: true

class CreateUserSkills < ActiveRecord::Migration[7.0]
  def change
    create_table :user_skills do |t|
      t.references :user, null: false, foreign_key: true
      t.references :skill, null: false, foreign_key: true
      t.string :level
      t.integer :last_applied_in_year

      t.timestamps
    end
  end
end
