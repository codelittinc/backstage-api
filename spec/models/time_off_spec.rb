# frozen_string_literal: true

# == Schema Information
#
# Table name: time_offs
#
#  id               :bigint           not null, primary key
#  ends_at          :datetime
#  starts_at        :datetime
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  time_off_type_id :bigint           not null
#  user_id          :bigint           not null
#
# Indexes
#
#  index_time_offs_on_time_off_type_id  (time_off_type_id)
#  index_time_offs_on_user_id           (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (time_off_type_id => time_off_types.id)
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe TimeOff, type: :model do
  context 'validations' do
    it { should validate_presence_of(:starts_at) }
    it { should validate_presence_of(:ends_at) }
  end

  context 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:time_off_type) }
  end
end
