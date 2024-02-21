# frozen_string_literal: true

# == Schema Information
#
# Table name: user_skills
#
#  id                   :bigint           not null, primary key
#  last_applied_in_year :integer
#  level                :string
#  years_of_experience  :float
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  skill_id             :bigint           not null
#  user_id              :bigint           not null
#
# Indexes
#
#  index_user_skills_on_skill_id              (skill_id)
#  index_user_skills_on_user_id               (user_id)
#  index_user_skills_on_user_id_and_skill_id  (user_id,skill_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (skill_id => skills.id)
#  fk_rails_...  (user_id => users.id)
#
class UserSkill < ApplicationRecord
  belongs_to :user
  belongs_to :skill

  VALID_LEVELS = %w[beginner intermediate advanced].freeze
  validates :level, presence: true, inclusion: { in: VALID_LEVELS }
  validates :last_applied_in_year, presence: true
  validates :years_of_experience, presence: true

  validates :user_id, uniqueness: { scope: :skill_id }
end
