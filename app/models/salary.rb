# frozen_string_literal: true

# == Schema Information
#
# Table name: salaries
#
#  id            :bigint           not null, primary key
#  start_date    :datetime
#  yearly_salary :float
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  user_id       :bigint           not null
#
# Indexes
#
#  index_salaries_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Salary < ApplicationRecord
  belongs_to :user

  validates :yearly_salary, numericality: { greater_than: 0 }, presence: true
  validates :start_date, presence: true

  HOURS_PER_YEAR = 2080

  def hourly_cost
    yearly_salary / HOURS_PER_YEAR
  end
end
