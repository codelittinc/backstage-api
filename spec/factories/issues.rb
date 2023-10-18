# frozen_string_literal: true

# == Schema Information
#
# Table name: issues
#
#  id          :bigint           not null, primary key
#  closed_date :datetime
#  effort      :float
#  state       :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :bigint           not null
#
# Indexes
#
#  index_issues_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
FactoryBot.define do
  factory :issue do
    effort { 1.5 }
    user
    state { 'Done' }
    closed_date { Date.new }
  end
end
