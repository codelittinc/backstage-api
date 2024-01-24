# frozen_string_literal: true

# == Schema Information
#
# Table name: statement_of_works
#
#  id                     :bigint           not null, primary key
#  contract_model_type    :string
#  end_date               :datetime
#  hour_delivery_schedule :string
#  hourly_revenue         :float
#  model                  :string
#  name                   :string
#  start_date             :datetime
#  total_hours            :float
#  total_revenue          :float
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  contract_model_id      :integer
#  project_id             :bigint           not null
#
# Indexes
#
#  index_sow_on_contract_model             (contract_model_id,contract_model_type)
#  index_statement_of_works_on_project_id  (project_id)
#
# Foreign Keys
#
#  fk_rails_...  (project_id => projects.id)
#
require 'rails_helper'

RSpec.describe StatementOfWork, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:start_date) }
    it { should validate_presence_of(:end_date) }
  end

  describe 'associations' do
    it { should belong_to(:project) }
    it { should have_many(:requirements) }
    it { should have_many(:time_entries) }
  end

  describe 'methods' do
    context '#active_in_period' do
      it 'should return true if dates are fully in the period' do
        create(:statement_of_work, :with_maintenance, start_date: '2020-01-01',
                                                      end_date: '2020-01-31')

        expect(StatementOfWork.active_in_period('2020-01-05', '2020-01-28').length).to eq(1)
      end

      it 'should return true if start date is in the period but the end date is out' do
        create(:statement_of_work, :with_maintenance, start_date: '2020-01-01',
                                                      end_date: '2020-01-31')

        expect(StatementOfWork.active_in_period('2020-01-05', '2020-02-28').length).to eq(1)
      end

      it 'should return true if start date is out of the period but the end date is in' do
        create(:statement_of_work, :with_maintenance, start_date: '2020-01-01',
                                                      end_date: '2020-01-31')

        expect(StatementOfWork.active_in_period('2019-01-05', '2020-02-28').length).to eq(1)
      end

      it 'should return true if both dates cover the start and end date' do
        create(:statement_of_work, :with_maintenance, start_date: '2020-01-01',
                                                      end_date: '2020-01-31')

        expect(StatementOfWork.active_in_period('2019-01-05', '2021-02-28').length).to eq(1)
      end

      it 'should return false if dates are fully out of the period' do
        create(:statement_of_work, :with_maintenance, start_date: '2020-01-01',
                                                      end_date: '2020-01-31')

        expect(StatementOfWork.active_in_period('2020-02-01', '2020-02-28').length).to eq(0)
      end
    end
  end
end
