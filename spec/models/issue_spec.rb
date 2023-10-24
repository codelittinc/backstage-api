# frozen_string_literal: true

# == Schema Information
#
# Table name: issues
#
#  id          :bigint           not null, primary key
#  closed_date :datetime
#  effort      :float
#  issue_type  :string
#  state       :string
#  title       :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  issue_id    :string
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
require 'rails_helper'

RSpec.describe Issue, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
  end
end
