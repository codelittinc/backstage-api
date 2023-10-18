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
#  project_id  :bigint           not null
#  user_id     :bigint           not null
#
# Indexes
#
#  index_issues_on_project_id  (project_id)
#  index_issues_on_user_id     (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (project_id => projects.id)
#  fk_rails_...  (user_id => users.id)
#
FactoryBot.define do
  factory :issue do
    effort { 1.5 }
    user
    project
    state { 'Done' }
    closed_date { Date.new }
  end
end
