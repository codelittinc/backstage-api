# frozen_string_literal: true

class AddUniqueIndexToUserSkillsOnUserIdAndSkillId < ActiveRecord::Migration[7.0]
  def change
    add_index :user_skills, %i[user_id skill_id], unique: true
  end
end
