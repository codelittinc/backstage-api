# frozen_string_literal: true

# == Schema Information
#
# Table name: customers
#
#  id                           :bigint           not null, primary key
#  name                         :string           not null
#  notifications_token          :string
#  source_control_token         :string
#  ticket_tracking_system_token :string
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#
# Indexes
#
#  index_customers_on_name  (name) UNIQUE
#
FactoryBot.define do
  factory :customer do
    name { FFaker::Company.name }
  end
end
