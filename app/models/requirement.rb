# frozen_string_literal: true

# == Schema Information
#
# Table name: requirements
#
#  id                   :bigint           not null, primary key
#  coverage             :float
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
class Requirement < ApplicationRecord
  belongs_to :profession
  belongs_to :statement_of_work

  validates :coverage, presence: true
end
