# frozen_string_literal: true

class User < ApplicationRecord
  extend FriendlyId
  friendly_id :full_name, use: :slugged

  # @TODO: decide if email is unique or not
  validates :email, presence: true, uniqueness: true
  # , format: {
  #                     with: /\A[\w+\-.]+@#{ENV.fetch('VALID_USER_DOMAIN', nil)}\z/i,
  #                     message: "must be a #{ENV.fetch('VALID_USER_DOMAIN', nil)} account"
  #                   }

  validates :google_id, presence: true, uniqueness: true

  belongs_to :profession, optional: true

  def full_name
    "#{first_name} #{last_name}"
  end
end
