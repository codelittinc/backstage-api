# frozen_string_literal: true

# == Schema Information
#
# Table name: salaries
#
#  id            :bigint           not null, primary key
#  start_date    :datetime
#  yearly_salary :float
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  user_id       :bigint           not null
#
# Indexes
#
#  index_salaries_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
FactoryBot.define do
  factory :salary do
    yearly_salary { 20_000 }
    start_date { Time.zone.today }
    user
  end
end
