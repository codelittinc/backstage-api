# frozen_string_literal: true

# == Schema Information
#
# Table name: time_entries
#
#  id                   :bigint           not null, primary key
#  date                 :date
#  hours                :float
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  statement_of_work_id :bigint           not null
#  user_id              :bigint           not null
#
# Indexes
#
#  index_time_entries_on_date_and_user_id_and_sow_id  (date,user_id,statement_of_work_id) UNIQUE
#  index_time_entries_on_statement_of_work_id         (statement_of_work_id)
#  index_time_entries_on_user_id                      (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (statement_of_work_id => statement_of_works.id)
#  fk_rails_...  (user_id => users.id)
#
FactoryBot.define do
  factory :time_entry do
    date { '2023-10-29' }
    hours { 8 }
    user { FactoryBot.create(:user) }
    statement_of_work { FactoryBot.create(:statement_of_work) }
  end
end
