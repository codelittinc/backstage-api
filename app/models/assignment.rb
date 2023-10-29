# frozen_string_literal: true

# == Schema Information
#
# Table name: assignments
#
#  id             :bigint           not null, primary key
#  coverage       :float
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  requirement_id :bigint           not null
#
# Indexes
#
#  index_assignments_on_requirement_id  (requirement_id)
#
# Foreign Keys
#
#  fk_rails_...  (requirement_id => requirements.id)
#
class Assignment < ApplicationRecord
  belongs_to :requirement

  validates :coverage, presence: true
end
