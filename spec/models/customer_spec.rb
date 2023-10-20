# frozen_string_literal: true

# == Schema Information
#
# Table name: customers
#
#  id                           :bigint           not null, primary key
#  name                         :string           not null
#  notifications_token          :string
#  slug                         :string
#  source_control_token         :string
#  ticket_tracking_system_token :string
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#
# Indexes
#
#  index_customers_on_name  (name) UNIQUE
#  index_customers_on_slug  (slug) UNIQUE
#
require 'rails_helper'

RSpec.describe Customer, type: :model do
  describe 'should validate the props' do
    subject { FactoryBot.build(:customer) }

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name) }
  end
end
