# frozen_string_literal: true

class Permission < ApplicationRecord
  has_many :user_permissions, dependent: :destroy
  has_many :users, through: :user_permissions

  validates :target, presence: true
  validates :ability, presence: true
end
