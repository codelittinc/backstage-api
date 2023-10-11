# frozen_string_literal: true

# == Schema Information
#
# Table name: professions
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

RSpec.describe Profession, type: :model do
  describe 'associations' do
    it { should have_many(:users) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
  end
end
