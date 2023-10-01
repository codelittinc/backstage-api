# frozen_string_literal: true

class UserPermission < ApplicationRecord
  belongs_to :user
  belongs_to :permission

  validates :user, presence: { message: 'must be present' }
  validates :permission, presence: { message: 'must be present' }
end
