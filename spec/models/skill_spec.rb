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
require 'rails_helper'

RSpec.describe Skill, type: :model do
  context 'validations' do
    it { should validate_presence_of(:name) }
  end

  context 'associations' do
    it { should have_many(:user_skills) }
    it { should have_many(:users).through(:user_skills) }
  end
end
