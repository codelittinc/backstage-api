# frozen_string_literal: true

# == Schema Information
#
# Table name: projects
#
#  id                          :bigint           not null, primary key
#  billable                    :boolean          default(TRUE), not null
#  end_date                    :date
#  logo_url                    :string
#  metadata                    :json
#  name                        :string
#  slack_channel               :string
#  slug                        :string
#  start_date                  :date
#  sync_source_control         :boolean          default(FALSE)
#  sync_ticket_tracking_system :boolean          default(FALSE)
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  customer_id                 :bigint           not null
#
# Indexes
#
#  index_projects_on_customer_id  (customer_id)
#  index_projects_on_slug         (slug) UNIQUE
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
