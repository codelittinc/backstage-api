# frozen_string_literal: true

# == Schema Information
#
# Table name: payments
#
#  id                   :bigint           not null, primary key
#  amount               :float
#  date                 :datetime
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  statement_of_work_id :bigint           not null
#
# Indexes
#
#  index_payments_on_statement_of_work_id  (statement_of_work_id)
#
# Foreign Keys
#
#  fk_rails_...  (statement_of_work_id => statement_of_works.id)
#
require 'rails_helper'

RSpec.describe Payment, type: :model do
  describe 'associations' do
    it { should belong_to(:statement_of_work) }
  end

  describe 'validations' do
    it { should validate_presence_of(:date) }
    it { should validate_presence_of(:amount) }
  end
end
