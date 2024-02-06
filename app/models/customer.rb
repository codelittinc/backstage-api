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
#  ticket_tracking_system       :string
#  ticket_tracking_system_token :string
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#
# Indexes
#
#  index_customers_on_name  (name) UNIQUE
#  index_customers_on_slug  (slug) UNIQUE
#
class Customer < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  validates :name, presence: true, uniqueness: true
  encrypts :source_control_token
  encrypts :notifications_token
  encrypts :ticket_tracking_system_token

  def should_generate_new_friendly_id?
    true
  end
end
