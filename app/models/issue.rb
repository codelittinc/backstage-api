# frozen_string_literal: true

# == Schema Information
#
# Table name: issues
#
#  id                :bigint           not null, primary key
#  board_column      :string
#  bug               :boolean          default(FALSE), not null
#  closed_date       :datetime
#  effort            :float
#  issue_type        :string
#  reported_at       :datetime
#  sprint            :string
#  sprint_end_date   :datetime
#  sprint_start_date :datetime
#  state             :string
#  title             :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  issue_id          :string
#  parent_tts_id     :string
#  project_id        :bigint           not null
#  tts_id            :string
#  user_id           :bigint
#
# Indexes
#
#  index_issues_on_project_id  (project_id)
#
# Foreign Keys
#
#  fk_rails_...  (project_id => projects.id)
#
class Issue < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :project
end
