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
FactoryBot.define do
  factory :payment do
    date { '2023-11-20 17:33:52' }
    amount { 1.5 }
    statement_of_work { nil }
  end
end
