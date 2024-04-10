# frozen_string_literal: true

# == Schema Information
#
# Table name: dynamic_datasets
#
#  id         :bigint           not null, primary key
#  code       :string
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  project_id :bigint           not null
#
# Indexes
#
#  index_dynamic_datasets_on_project_id  (project_id)
#
# Foreign Keys
#
#  fk_rails_...  (project_id => projects.id)
#
require 'rails_helper'

RSpec.describe DynamicDataset, type: :model do
  context '#execute' do
    it 'executes the code and returns the result' do
      users = create_list(:user, 5)
      expected_result = users.map { |user| [user.id, user.first_name] }
      code = 'User.all.pluck(:id, :first_name)'
      dynamic_dataset = create(:dynamic_dataset, code:)
      result = dynamic_dataset.execute
      expect(result).to eq(expected_result)
    end
  end
end
