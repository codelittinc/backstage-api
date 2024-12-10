# frozen_string_literal: true

class AddProfessionalAreaToSkill < ActiveRecord::Migration[7.0]
  def change
    add_column :skills, :professional_area, :string
  end
end
