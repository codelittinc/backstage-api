# frozen_string_literal: true

# == Schema Information
#
# Table name: project_reports
#
#  id         :bigint           not null, primary key
#  key        :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  project_id :bigint           not null
#
# Indexes
#
#  index_project_reports_on_project_id  (project_id)
#
# Foreign Keys
#
#  fk_rails_...  (project_id => projects.id)
#
require 'rails_helper'

RSpec.describe ProjectReport, type: :model do
  context 'associations' do
    it { should belong_to(:project) }
  end
end
