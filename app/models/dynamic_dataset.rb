# frozen_string_literal: true

# == Schema Information
#
# Table name: dynamic_datasets
#
#  id         :bigint           not null, primary key
#  code       :string
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  project_id :bigint           not null
#
# Indexes
#
#  index_dynamic_datasets_on_project_id  (project_id)
#
# Foreign Keys
#
#  fk_rails_...  (project_id => projects.id)
#
class DynamicDataset < ApplicationRecord
  belongs_to :project

  def execute
    # Use `eval` to execute the code. Be very cautious with this approach.
    eval(code)
  rescue StandardError => e
    "Error executing code: #{e.message}"
  end
end