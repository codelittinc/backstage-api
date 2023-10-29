# frozen_string_literal: true

# == Schema Information
#
# Table name: statement_of_works
#
#  id                         :bigint           not null, primary key
#  end_date                   :datetime
#  hour_delivery_schedule     :string
#  hourly_revenue             :float
#  limit_by_delivery_schedule :boolean          default(TRUE), not null
#  model                      :string
#  start_date                 :datetime
#  total_hours                :float
#  total_revenue              :float
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  project_id                 :bigint           not null
#
# Indexes
#
#  index_statement_of_works_on_project_id  (project_id)
#
# Foreign Keys
#
#  fk_rails_...  (project_id => projects.id)
#

class StatementOfWork < ApplicationRecord
  belongs_to :project
  has_many :requirements, dependent: :destroy
  has_many :time_entries, dependent: :destroy

  # existing validations
  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :model, presence: true, inclusion: { in: %w[maintenance time_and_materials fixed_bid] }
  validates :total_revenue, numericality: { greater_than: 0 }
  validates :hour_delivery_schedule, presence: true, inclusion: { in: %w[contract_period weekly monthly] }

  # custom validation for date range
  validate :validate_date_range

  private

  def validate_date_range
    return unless start_date && end_date && start_date >= end_date

    errors.add(:start_date, 'must be before end date')
    errors.add(:end_date, 'must be after start date')
  end
end
