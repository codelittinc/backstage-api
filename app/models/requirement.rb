# frozen_string_literal: true

# == Schema Information
#
# Table name: requirements
#
#  id                   :bigint           not null, primary key
#  coverage             :float
#  end_date             :date
#  start_date           :date
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  profession_id        :bigint           not null
#  statement_of_work_id :bigint           not null
#
# Indexes
#
#  index_requirements_on_profession_id         (profession_id)
#  index_requirements_on_statement_of_work_id  (statement_of_work_id)
#
# Foreign Keys
#
#  fk_rails_...  (profession_id => professions.id)
#  fk_rails_...  (statement_of_work_id => statement_of_works.id)
#
class Requirement < ApplicationRecord
  belongs_to :profession
  belongs_to :statement_of_work
  has_many :assignments, dependent: :destroy

  validates :coverage, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true

  scope :active_in_period, ->(start_date, end_date) { where('start_date <= ? AND end_date >= ?', end_date, start_date) }
end
