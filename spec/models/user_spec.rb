# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'should validate the props' do
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_uniqueness_of(:email) }
    it { is_expected.to validate_presence_of(:google_id) }
    it { is_expected.to validate_uniqueness_of(:google_id) }
    it { is_expected.to validate_inclusion_of(:seniority).in_array(%w[intern junior midlevel senior]) }
    it { is_expected.to validate_inclusion_of(:active).in_array([true, false]) }

    it 'validates the seniority' do
      user = FactoryBot.create(:user)
      valid_seniority = User::VALID_SENIORITIES.sample
      user.seniority = valid_seniority
      expect(user.save).to be_truthy
    end

    it 'validates the seniority to be potentially nil' do
      user = FactoryBot.create(:user)
      user.seniority = nil
      expect(user.save).to be_truthy
    end

    it 'validates the contract_type' do
      user = FactoryBot.create(:user)
      user.contract_type = nil
      expect(user.valid?).to be_truthy
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:profession).optional(true) }
    it { is_expected.to have_many(:user_permissions).dependent(:destroy) }
    it { is_expected.to have_many(:permissions).through(:user_permissions) }
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
