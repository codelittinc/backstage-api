# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'should validate the props' do
    it { is_expected.to validate_presence_of(:first_name) }
    it { is_expected.to validate_presence_of(:last_name) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_uniqueness_of(:email) }
    it { is_expected.to validate_presence_of(:google_id) }
    it { is_expected.to validate_uniqueness_of(:google_id) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:profession).optional(true) }
    it { is_expected.to have_many(:user_permissions).optional(true) }
  end

  context 'when creating a new user' do
    it 'defines the slug value as the full name' do
      user = FactoryBot.create(:user)
      expect(user.slug).to eql("#{user.first_name}-#{user.last_name}".downcase)
    end
  end

  context 'when using a slug to identify the user' do
    it 'finds the correct user' do
      user = FactoryBot.create(:user)
      expect(User.friendly.find(user.slug)).to eql(user)
    end
  end
end
