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
end
