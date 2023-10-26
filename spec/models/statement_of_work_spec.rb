# frozen_string_literal: true

# == Schema Information
#
# Table name: statement_of_works
#
#  id                         :bigint           not null, primary key
#  end_date                   :datetime
#  hour_delivery_schedule     :string
#  hourly_revenue             :float
#  limit_by_delivery_schedule :boolean          default(TRUE), not null
#  model                      :string
#  start_date                 :datetime
#  total_hours                :float
#  total_revenue              :float
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  project_id                 :bigint           not null
#
# Indexes
#
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
  end
end
