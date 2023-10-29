# frozen_string_literal: true

# == Schema Information
#
# Table name: requirements
#
#  id                   :bigint           not null, primary key
#  coverage             :float
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  profession_id        :bigint           not null
#  statement_of_work_id :bigint           not null
#
# Indexes
#
#  index_requirements_on_profession_id         (profession_id)
#  index_requirements_on_statement_of_work_id  (statement_of_work_id)
#
# Foreign Keys
#
#  fk_rails_...  (profession_id => professions.id)
#  fk_rails_...  (statement_of_work_id => statement_of_works.id)
#
require 'rails_helper'

RSpec.describe Requirement, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:coverage) }
  end

  describe 'associations' do
    it { should belong_to(:statement_of_work) }
    it { should belong_to(:profession) }
    it { should have_many(:assignments) }
  end
end
