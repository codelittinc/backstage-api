# frozen_string_literal: true

# == Schema Information
#
# Table name: projects
#
#  id                          :bigint           not null, primary key
#  billable                    :boolean          default(TRUE), not null
#  display_code_metrics        :boolean          default(FALSE), not null
#  display_tasks_metrics       :boolean          default(FALSE), not null
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
  has_many :dynamic_datasets, dependent: :destroy
  has_one :project_report, dependent: :destroy

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :billable, inclusion: { in: [true, false] }
  validates :slack_channel, presence: true

  validate :validate_display_tasks_metrics
  validate :validate_sync_ticket_tracking_system
  validate :validate_sync_source_control
  validate :validate_display_code_metrics
  after_create :create_project_report

  def create_project_report
    build_project_report.save
  end

  def validate_display_tasks_metrics
    return unless display_tasks_metrics && !sync_ticket_tracking_system

    errors.add(:display_tasks_metrics, 'cannot be true if sync_ticket_tracking_system is false')
  end

  def validate_display_code_metrics
    return unless display_code_metrics && !sync_source_control

    errors.add(:display_tasks_metrics, 'cannot be true if sync_source_control is false')
  end

  def validate_sync_ticket_tracking_system
    return unless sync_ticket_tracking_system && customer.source_control_token.blank?

    errors.add(:sync_ticket_tracking_system, "can't be true if customer's source_control_token is empty")
  end

  def validate_sync_source_control
    return unless sync_source_control && customer.source_control_token.blank?

    errors.add(:sync_source_control, "can't be true if customer's source_control_token is empty")
  end

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
    date = Time.zone.today

    # Get the active statement of works in the given period
    active_sows = statement_of_works.active_in_period(date, date)

    # Find all the related requirements that are active in the period while keeping it as an ActiveRecord relation
    active_requirements = Requirement.where(statement_of_work_id: active_sows.pluck(:id))
                                     .active_in_period(date, date)

    # Get the users related to assignments from the active requirements
    User.joins(assignments: :requirement)
        .where(assignments: { requirement_id: active_requirements.pluck(:id) })
        .distinct
  end
end
