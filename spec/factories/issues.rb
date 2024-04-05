# frozen_string_literal: true

# == Schema Information
#
# Table name: issues
#
#  id          :bigint           not null, primary key
#  bug         :boolean          default(FALSE), not null
#  closed_date :datetime
#  effort      :float
#  issue_type  :string
#  reported_at :datetime
#  state       :string
#  title       :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  issue_id    :string
#  project_id  :bigint           not null
#  tts_id      :string
#  user_id     :bigint
#
# Indexes
#
#  index_issues_on_project_id  (project_id)
#
# Foreign Keys
#
#  fk_rails_...  (project_id => projects.id)
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
