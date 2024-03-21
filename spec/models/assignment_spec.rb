# frozen_string_literal: true

# == Schema Information
#
# Table name: assignments
#
#  id             :bigint           not null, primary key
#  coverage       :float
#  end_date       :datetime
#  start_date     :datetime
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  requirement_id :bigint           not null
#  user_id        :bigint           not null
#
# Indexes
#
#  index_assignments_on_requirement_id  (requirement_id)
#  index_assignments_on_user_id         (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (requirement_id => requirements.id)
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe Assignment, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:coverage) }
  end

  describe 'associations' do
    it { should belong_to(:requirement) }
  end
end
