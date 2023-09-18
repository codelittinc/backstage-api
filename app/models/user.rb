# frozen_string_literal: true

class User < ApplicationRecord
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, uniqueness: true,
                    format: {
                      with: /\A[\w+\-.]+@#{ENV.fetch('VALID_USER_DOMAIN', nil)}\z/i,
                      message: "must be a #{ENV.fetch('VALID_USER_DOMAIN', nil)} account"
                    }

  validates :google_id, presence: true, uniqueness: true
end
