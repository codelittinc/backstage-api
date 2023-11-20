# frozen_string_literal: true

# == Schema Information
#
# Table name: requirements
#
#  id                   :bigint           not null, primary key
#  coverage             :float
#  end_date             :date
#  start_date           :date
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  profession_id        :bigint           not null
#  statement_of_work_id :bigint           not null
#
# Indexes
#
#  index_requirements_on_profession_id         (profession_id)
#  index_requirements_on_statement_of_work_id  (statement_of_work_id)
#
# Foreign Keys
#
#  fk_rails_...  (profession_id => professions.id)
#  fk_rails_...  (statement_of_work_id => statement_of_works.id)
#
FactoryBot.define do
  factory :requirement do
    profession
    statement_of_work factory: %i[statement_of_work with_maintenance]
    coverage { 1.0 }
  end
end
