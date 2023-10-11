# frozen_string_literal: true

# == Schema Information
#
# Table name: permissions
#
#  id         :bigint           not null, primary key
#  target     :string
#  ability    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

RSpec.describe Permission, type: :model do
  describe 'associations' do
    it { should have_many(:user_permissions).dependent(:destroy) }
    it { should have_many(:users).through(:user_permissions) }
  end

  describe 'validations' do
    it { should validate_presence_of(:target) }
    it { should validate_presence_of(:ability) }
  end
end
