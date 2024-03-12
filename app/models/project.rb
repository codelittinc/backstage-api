# frozen_string_literal: true

# == Schema Information
#
# Table name: projects
#
#  id                          :bigint           not null, primary key
#  billable                    :boolean          default(TRUE), not null
#  logo_background_color       :string
#  logo_url                    :string
#  metadata                    :json
#  name                        :string
#  slack_channel               :string
#  slug                        :string
#  sync_source_control         :boolean          default(FALSE), not null
#  sync_ticket_tracking_system :boolean          default(FALSE), not null
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  customer_id                 :bigint           not null
#
# Indexes
#
#  index_projects_on_customer_id  (customer_id)
#  index_projects_on_name         (name) UNIQUE
#  index_projects_on_slug         (slug) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (customer_id => customers.id)
#
class Project < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  belongs_to :customer
  has_many :issues, dependent: :destroy
  has_many :statement_of_works, dependent: :destroy

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :billable, inclusion: { in: [true, false] }
  validates :slack_channel, presence: true

  scope :active_in_period, lambda { |start_date, end_date|
    where(id: StatementOfWork.active_in_period(start_date, end_date).select(:project_id).distinct)
  }

  scope :with_ticket_system, lambda {
    joins(:customer)
      .where.not(customers: { ticket_tracking_system_token: nil })
      .where.not(customers: { ticket_tracking_system: nil })
  }

  def should_generate_new_friendly_id?
    true
  end

  def participants
    users = statement_of_works.active_in_period(Time.zone.today,
                                                Time.zone.today).map(&:requirements)
                              .flatten.map(&:assignments).flatten.map(&:user).flatten
    User.where(id: users.map(&:id)).distinct
  end
end
