# frozen_string_literal: true

# == Schema Information
#
# Table name: projects
#
#  id                          :bigint           not null, primary key
#  billable                    :boolean          default(TRUE), not null
#  display_code_metrics        :boolean          default(FALSE), not null
#  display_tasks_metrics       :boolean          default(FALSE), not null
#  logo_background_color       :string
#  logo_url                    :string
#  metadata                    :json
#  name                        :string
#  slack_channel               :string
#  slug                        :string
#  sync_source_control         :boolean          default(FALSE), not null
#  sync_ticket_tracking_system :boolean          default(FALSE), not null
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  customer_id                 :bigint           not null
#
# Indexes
#
#  index_projects_on_customer_id  (customer_id)
#  index_projects_on_name         (name) UNIQUE
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
    customer
  end
end
