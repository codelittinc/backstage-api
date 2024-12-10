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
class Skill < ApplicationRecord
  has_many :user_skills, dependent: :destroy
  has_many :users, through: :user_skills

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :professional_area, presence: true, inclusion: { in: %w[design engineering] }
end
