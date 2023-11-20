# frozen_string_literal: true

# == Schema Information
#
# Table name: payments
#
#  id                   :bigint           not null, primary key
#  amount               :float
#  date                 :datetime
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  statement_of_work_id :bigint           not null
#
# Indexes
#
#  index_payments_on_statement_of_work_id  (statement_of_work_id)
#
# Foreign Keys
#
#  fk_rails_...  (statement_of_work_id => statement_of_works.id)
#
class Payment < ApplicationRecord
  belongs_to :statement_of_work

  validates :amount, presence: true
  validates :date, presence: true

  scope :executed_between, ->(start_date, end_date) { where('date <= ? AND date >= ?', end_date, start_date) }
end
