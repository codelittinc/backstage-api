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
require 'rails_helper'

RSpec.describe Salary, type: :model do
  context 'validations' do
    it { is_expected.to validate_presence_of(:yearly_salary) }
    it { is_expected.to validate_numericality_of(:yearly_salary).is_greater_than(0) }
    it { is_expected.to validate_presence_of(:start_date) }
  end

  context 'associations' do
    it { is_expected.to belong_to(:user) }
  end
end
