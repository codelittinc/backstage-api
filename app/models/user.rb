# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id            :bigint           not null, primary key
#  active        :boolean          default(TRUE), not null
#  contract_type :string
#  country       :string
#  email         :string
#  first_name    :string
#  image_url     :string
#  last_name     :string
#  seniority     :string
#  slug          :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  google_id     :string
#  profession_id :bigint
#
# Indexes
#
#  index_users_on_email          (email) UNIQUE
#  index_users_on_google_id      (google_id) UNIQUE
#  index_users_on_profession_id  (profession_id)
#  index_users_on_slug           (slug) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (profession_id => professions.id)
#
class User < ApplicationRecord
  extend FriendlyId
  friendly_id :full_name, use: :slugged

  # @TODO: decide if email is unique or not
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  # , format: {
  #                     with: /\A[\w+\-.]+@#{ENV.fetch('VALID_USER_DOMAIN', nil)}\z/i,
  #                     message: "must be a #{ENV.fetch('VALID_USER_DOMAIN', nil)} account"
  #                   }

  validates :google_id, presence: true, uniqueness: true

  VALID_SENIORITIES = %w[Intern Junior Midlevel Senior].freeze
  validates :seniority, inclusion: { in: VALID_SENIORITIES, allow_nil: true }
  validates :active, inclusion: { in: [true, false] }

  belongs_to :profession, optional: true
  has_many :user_permissions, dependent: :destroy
  has_many :permissions, through: :user_permissions
  has_many :user_service_identifiers, dependent: :destroy
  accepts_nested_attributes_for :user_service_identifiers

  def full_name
    "#{first_name} #{last_name}"
  end

  scope :by_external_identifier, lambda { |identifier|
                                   joins(:user_service_identifiers)
                                     .where(user_service_identifiers: { identifier: })
                                 }
end
