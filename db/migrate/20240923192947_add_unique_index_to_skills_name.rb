# frozen_string_literal: true

class AddUniqueIndexToSkillsName < ActiveRecord::Migration[7.0]
  def change
    add_index :skills, 'LOWER(name)', unique: true, name: 'index_skills_on_lower_name'
  end
end
