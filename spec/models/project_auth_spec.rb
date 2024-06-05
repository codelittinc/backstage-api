# frozen_string_literal: true

# == Schema Information
#
# Table name: project_auths
#
#  id         :bigint           not null, primary key
#  key        :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  project_id :bigint           not null
#
# Indexes
#
#  index_project_auths_on_project_id  (project_id)
#
# Foreign Keys
#
#  fk_rails_...  (project_id => projects.id)
#
require 'rails_helper'

RSpec.describe ProjectAuth, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
