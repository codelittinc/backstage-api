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
#  history       :text
#  image_url     :string
#  internal      :boolean          default(TRUE), not null
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

    it 'does not validate uniqueness of google_id if the user is not internal' do
      create(:user, internal: false, google_id: nil)
      user2 = build(:user, internal: false, google_id: nil)

      expect(user2.valid?).to be_truthy
    end

    it 'validates the seniority' do
      user = create(:user)
      valid_seniority = User::VALID_SENIORITIES.sample
      user.seniority = valid_seniority
      expect(user.save).to be_truthy
    end

    it 'validates the seniority to be potentially nil' do
      user = create(:user)
      user.seniority = nil
      expect(user.save).to be_truthy
    end

    it 'validates the contract_type' do
      user = create(:user)
      user.contract_type = nil
      expect(user.valid?).to be_truthy
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:profession).optional(true) }
    it { is_expected.to have_many(:user_permissions).dependent(:destroy) }
    it { is_expected.to have_many(:permissions).through(:user_permissions) }
    it { is_expected.to have_many(:certifications).dependent(:destroy) }
    it { is_expected.to have_many(:user_skills).dependent(:destroy) }
    it { is_expected.to have_many(:skills).through(:user_skills) }
    it { is_expected.to have_many(:salaries).dependent(:destroy) }
  end

  context 'when creating a new user' do
    it 'defines the slug value as the full name' do
      user = create(:user)
      expect(user.slug).to eql("#{user.first_name}-#{user.last_name}".downcase)
    end
  end

  context 'when using a slug to identify the user' do
    it 'finds the correct user' do
      user = create(:user)
      expect(User.friendly.find(user.slug)).to eql(user)
    end
  end

  context '#by_external_identifier' do
    it 'returns the user by the identifier' do
      user = create(:user)
      user_service_identifier = create(:user_service_identifier, user:, identifier: 'codelittinc')
      expect(User.by_external_identifier(user_service_identifier.identifier).first).to eql(user)
    end

    it 'returns the user by the email' do
      user = create(:user, email: 'bruce.wayne@codelitt.com')
      expect(User.by_external_identifier(user.email).first).to eql(user)
    end

    it 'returns the user by the user id' do
      user = create(:user, email: 'bruce.wayne@codelitt.com')

      expect(User.by_external_identifier(user.id).first).to eql(user)
    end
  end

  context '#by_name' do
    let(:full_name) { 'Pedro Vieira Guimarães' }

    context 'when the user exists' do
      it 'returns the user by the name' do
        user = create(:user, first_name: 'Pedro', last_name: 'Vieira')
        expect(User.by_name(full_name).first).to eql(user)
      end
    end

    it 'returns an active record query' do
      expect(User.by_name(full_name)).to be_an(ActiveRecord::Relation)
    end
  end
end
