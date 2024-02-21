# frozen_string_literal: true

class AddYearsOfExperienceToUserSkill < ActiveRecord::Migration[7.0]
  def change
    add_column :user_skills, :years_of_experience, :float
  end
end
