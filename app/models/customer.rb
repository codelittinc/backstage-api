# frozen_string_literal: true

class Customer < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  encrypts :source_control_token
  encrypts :notifications_token
end
