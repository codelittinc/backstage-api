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
#  internal      :boolean          default(TRUE), not null
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
#  index_users_on_profession_id  (profession_id)
#  index_users_on_slug           (slug) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (profession_id => professions.id)
#
class User < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  validates :email, presence: true, uniqueness: true
  validates :email, format: {
    with: /\A[\w+\-.]+@#{ENV.fetch('VALID_USER_DOMAIN', nil)}\z/i,
    message: "must be a #{ENV.fetch('VALID_USER_DOMAIN', nil)} account"
  }, if: :internal?

  validates :google_id, presence: true, uniqueness: true, if: :internal?
  validates :google_id, absence: true, unless: :internal?

  VALID_SENIORITIES = %w[Intern Junior Midlevel Senior].freeze
  validates :seniority, inclusion: { in: VALID_SENIORITIES, allow_nil: true }
  validates :active, inclusion: { in: [true, false] }

  belongs_to :profession, optional: true
  has_many :user_permissions, dependent: :destroy
  has_many :permissions, through: :user_permissions
  has_many :user_service_identifiers, dependent: :destroy
  accepts_nested_attributes_for :user_service_identifiers
  has_many :certifications, dependent: :destroy
  has_many :user_skills, dependent: :destroy
  has_many :skills, through: :user_skills
  has_many :salaries, dependent: :destroy
  has_many :time_offs, dependent: :destroy
  has_many :assignments, dependent: :destroy
  has_many :time_entries, dependent: :destroy
  accepts_nested_attributes_for :salaries

  def name
    "#{first_name} #{last_name}"
  end

  scope :by_external_identifier, lambda { |identifiers|
                                   identifiers = [identifiers].flatten.compact.map(&:to_s).map(&:downcase)
                                   joins('LEFT JOIN user_service_identifiers ON users.id = user_service_identifiers.user_id')
                                     .where('lower(users.email) IN (:identifiers) OR lower(user_service_identifiers.identifier) IN
                                      (:identifiers) OR CAST(users.id AS TEXT) IN (:identifiers)',
                                            identifiers:)
                                 }

  def self.by_name(full_name)
    name_parts = full_name.split
    first_name = name_parts.first
    last_name_parts = name_parts[1..].join(' ')
    query = User.where('unaccent(lower(first_name)) = unaccent(lower(?))', first_name.downcase)

    last_names_condition = last_name_parts.split.map do |part|
      "unaccent(lower(last_name)) LIKE unaccent(lower('%#{part}%'))"
    end.join(' OR ')

    query.where(last_names_condition)
  end

  def should_generate_new_friendly_id?
    true
  end

  def salary_on_date(date)
    salaries.where('start_date <= ?', date).order(start_date: :desc).first
  end
end
