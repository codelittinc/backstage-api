# frozen_string_literal: true

# == Schema Information
#
# Table name: projects
#
#  id                          :bigint           not null, primary key
#  billable                    :boolean          default(TRUE), not null
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
#  index_projects_on_slug         (slug) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (customer_id => customers.id)
#
require 'rails_helper'

RSpec.describe Project, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:slack_channel) }
  end

  context 'associations' do
    it { should have_many(:issues).dependent(:destroy) }
    it { should have_many(:statement_of_works).dependent(:destroy) }
  end
end
