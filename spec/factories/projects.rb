# frozen_string_literal: true

# == Schema Information
#
# Table name: projects
#
#  id            :bigint           not null, primary key
#  billable      :boolean          default(TRUE), not null
#  end_date      :date
#  metadata      :json
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
FactoryBot.define do
  factory :project do
    name { FFaker::Lorem.word }
    billable { true }
    slack_channel { FFaker::Lorem.word }
    start_date { Time.zone.today }
    end_date { Time.zone.today + 1.month }
    customer
  end
end
