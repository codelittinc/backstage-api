# frozen_string_literal: true

# == Schema Information
#
# Table name: statement_of_works
#
#  id                  :bigint           not null, primary key
#  contract_model_type :string
#  end_date            :datetime
#  model               :string
#  name                :string
#  start_date          :datetime
#  total_hours         :float
#  total_revenue       :float
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  contract_model_id   :integer
#  project_id          :bigint           not null
#
# Indexes
#
#  index_sow_on_contract_model             (contract_model_id,contract_model_type)
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
  has_many :payments, dependent: :destroy
  belongs_to :contract_model, polymorphic: true, optional: true

  # existing validations
  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :model, presence: true, inclusion: { in: %w[maintenance time_and_materials fixed_bid] }
  validates :total_revenue, numericality: { greater_than: 0 }

  # custom validation for date range
  validate :validate_date_range

  scope :active_in_period, ->(start_date, end_date) { where('start_date <= ? AND end_date >= ?', end_date, start_date) }
  scope :maintenance, -> { where(model: 'maintenance') }
  scope :time_and_materials, -> { where(model: 'time_and_materials') }

  private

  def validate_date_range
    return unless start_date && end_date && start_date >= end_date

    errors.add(:start_date, 'must be before end date')
    errors.add(:end_date, 'must be after start date')
  end
end
