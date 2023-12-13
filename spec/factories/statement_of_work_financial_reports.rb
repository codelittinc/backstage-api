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
FactoryBot.define do
  factory :statement_of_work_financial_report do
    statement_of_work { nil }
    start_date { '2023-12-13 19:57:44' }
    end_date { '2023-12-13 19:57:44' }
    total_executed_income { 1.5 }
  end
end
