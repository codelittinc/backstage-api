# frozen_string_literal: true

# == Schema Information
#
# Table name: requirements
#
#  id                   :bigint           not null, primary key
#  coverage             :float
#  end_date             :datetime
#  start_date           :datetime
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

  describe 'methods' do
    context '#active_in_period' do
      it 'should return true if dates are fully in the period' do
        create(:requirement, start_date: '2020-01-01',
                             end_date: '2020-01-31')

        expect(Requirement.active_in_period('2020-01-05', '2020-01-28').length).to eq(1)
      end

      it 'should return true if start date is in the period but the end date is out' do
        create(:requirement, start_date: '2020-01-01',
                             end_date: '2020-01-31')

        expect(Requirement.active_in_period('2020-01-05', '2020-02-28').length).to eq(1)
      end

      it 'should return true if start date is out of the period but the end date is in' do
        create(:requirement, start_date: '2020-01-01',
                             end_date: '2020-01-31')

        expect(Requirement.active_in_period('2019-01-05', '2020-02-28').length).to eq(1)
      end

      it 'should return true if both dates cover the start and end date' do
        create(:requirement, start_date: '2020-01-01',
                             end_date: '2020-01-31')

        expect(Requirement.active_in_period('2019-01-05', '2021-02-28').length).to eq(1)
      end

      it 'should return false if dates are fully out of the period' do
        create(:requirement, start_date: '2020-01-01',
                             end_date: '2020-01-31')

        expect(Requirement.active_in_period('2020-02-01', '2020-02-28').length).to eq(0)
      end
    end
  end
end
