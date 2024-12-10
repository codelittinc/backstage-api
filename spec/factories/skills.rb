# frozen_string_literal: true

# == Schema Information
#
# Table name: skills
#
#  id                :bigint           not null, primary key
#  name              :string
#  professional_area :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_skills_on_lower_name  (lower((name)::text)) UNIQUE
#
FactoryBot.define do
  factory :skill do
    name { FFaker::Skill.tech_skill }
  end
end
