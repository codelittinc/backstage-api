# frozen_string_literal: true

# == Schema Information
#
# Table name: projects
#
#  id            :bigint           not null, primary key
#  billable      :boolean          default(TRUE), not null
#  end_date      :date
#  name          :string
#  slack_channel :string
#  start_date    :date
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  customer_id   :bigint           not null
#
# Indexes
#
#  index_projects_on_customer_id  (customer_id)
#
# Foreign Keys
#
#  fk_rails_...  (customer_id => customers.id)
#
require 'rails_helper'

RSpec.describe Project, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_inclusion_of(:billable).in_array([true, false]) }
    it { should validate_presence_of(:billable) }
    it { should validate_presence_of(:slack_channel) }
    it { should validate_presence_of(:start_date) }
    it { should validate_presence_of(:end_date) }
  end
end
