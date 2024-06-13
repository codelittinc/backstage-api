# frozen_string_literal: true

# == Schema Information
#
# Table name: project_reports
#
#  id         :bigint           not null, primary key
#  key        :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  project_id :bigint           not null
#
# Indexes
#
#  index_project_reports_on_project_id  (project_id)
#
# Foreign Keys
#
#  fk_rails_...  (project_id => projects.id)
#
class ProjectReport < ApplicationRecord
  belongs_to :project

  before_create :generate_key, unless: :key_present?

  private

  def generate_key
    self.key = SecureRandom.hex(10) # Generates a random hex string of 20 characters
  end

  def key_present?
    key.present?
  end
end
