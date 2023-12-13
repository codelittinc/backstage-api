# frozen_string_literal: true

# == Schema Information
#
# Table name: statement_of_work_financial_reports
#
#  id                    :bigint           not null, primary key
#  end_date              :datetime
#  start_date            :datetime
#  total_executed_income :float
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  statement_of_work_id  :integer          not null
#
# Indexes
#
#  index_sow_financial_reports_on_sow_id  (statement_of_work_id)
#
class StatementOfWorkFinancialReport < ApplicationRecord
  belongs_to :statement_of_work

  scope :ending_on, lambda { |filter|
    where(end_date: filter.to_date)
  }
end
