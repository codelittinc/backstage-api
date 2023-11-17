# frozen_string_literal: true

# == Schema Information
#
# Table name: projects
#
#  id            :bigint           not null, primary key
#  billable      :boolean          default(TRUE), not null
#  end_date      :date
#  logo_url      :string
#  metadata      :json
#  name          :string
#  slack_channel :string
#  slug          :string
#  start_date    :date
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  customer_id   :bigint           not null
#
# Indexes
#
#  index_projects_on_customer_id  (customer_id)
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

  validates :name, presence: true
  validates :billable, inclusion: { in: [true, false] }
  validates :slack_channel, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true

  scope :active_on, ->(date) { where('start_date <= :date and end_date >= :date', date:) }

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
end
