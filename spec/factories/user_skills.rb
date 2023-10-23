# frozen_string_literal: true

# == Schema Information
#
# Table name: user_skills
#
#  id                   :bigint           not null, primary key
#  last_applied_in_year :integer
#  level                :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  skill_id             :bigint           not null
#  user_id              :bigint           not null
#
# Indexes
#
#  index_user_skills_on_skill_id  (skill_id)
#  index_user_skills_on_user_id   (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (skill_id => skills.id)
#  fk_rails_...  (user_id => users.id)
#
FactoryBot.define do
  factory :user_skill do
    user
    skill
    level { UserSkill::VALID_LEVELS.sample }
    last_applied_in_year { 2020 }
  end
end
