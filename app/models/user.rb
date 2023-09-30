# frozen_string_literal: true

class User < ApplicationRecord
  extend FriendlyId
  friendly_id :full_name, use: :slugged

  validates :email, presence: true, uniqueness: true
  # , format: {
  #                     with: /\A[\w+\-.]+@#{ENV.fetch('VALID_USER_DOMAIN', nil)}\z/i,
  #                     message: "must be a #{ENV.fetch('VALID_USER_DOMAIN', nil)} account"
  #                   }

  validates :google_id, presence: true, uniqueness: true
  validates :first_name, presence: true
  validates :last_name, presence: true

  belongs_to :profession, optional: true
  has_many :user_permissions
  has_many :permissions, through: :user_permissions

  def full_name
    "#{first_name} #{last_name}"
  end
end
