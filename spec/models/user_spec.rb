# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id            :bigint           not null, primary key
#  active        :boolean          default(TRUE), not null
#  contract_type :string
#  country       :string
#  email         :string
#  first_name    :string
#  image_url     :string
#  last_name     :string
#  seniority     :string
#  slug          :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  google_id     :string
#  profession_id :bigint
#
# Indexes
#
#  index_users_on_email          (email) UNIQUE
#  index_users_on_google_id      (google_id) UNIQUE
#  index_users_on_profession_id  (profession_id)
#  index_users_on_slug           (slug) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (profession_id => professions.id)
#
require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'should validate the props' do
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_uniqueness_of(:email) }
    it { is_expected.to validate_presence_of(:google_id) }
    it { is_expected.to validate_uniqueness_of(:google_id) }
    it { is_expected.to validate_inclusion_of(:seniority).in_array(%w[Intern Junior Midlevel Senior]) }

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
    it { is_expected.to have_many(:certifications).dependent(:destroy) }
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

  context '#by_external_identifier' do
    it 'returns the user by the identifier' do
      user = FactoryBot.create(:user)
      user_service_identifier = FactoryBot.create(:user_service_identifier, user:, identifier: 'codelittinc')
      expect(User.by_external_identifier(user_service_identifier.identifier).first).to eql(user)
    end
  end
end
