# frozen_string_literal: true

# == Schema Information
#
# Table name: dynamic_datasets
#
#  id         :bigint           not null, primary key
#  code       :text
#  name       :string
#  order      :integer
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
FactoryBot.define do
  factory :dynamic_dataset do
    name { 'MyString' }
    code { 'MyString' }
    project { FactoryBot.create(:project) }
  end
end
