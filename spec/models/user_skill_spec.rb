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
require 'rails_helper'

RSpec.describe UserSkill, type: :model do
  context 'validations' do
    it { should validate_presence_of(:level) }
    it { should validate_presence_of(:last_applied_in_year) }
    it { should validate_inclusion_of(:level).in_array(UserSkill::VALID_LEVELS) }
  end

  context 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:skill) }
  end
end
