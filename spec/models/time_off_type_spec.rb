# frozen_string_literal: true

# == Schema Information
#
# Table name: time_off_types
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

RSpec.describe TimeOffType, type: :model do
  context 'validations' do
    it { should validate_presence_of(:name) }
  end
end
