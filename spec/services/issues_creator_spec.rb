# frozen_string_literal: true

require 'rails_helper'

RSpec.describe IssuesCreator, type: :service do
  let(:customer) do
    FactoryBot.create(:customer, name: 'Ministry Brands', ticket_tracking_system_token: 'place-real-token-here')
  end

  let(:user) do
    user = FactoryBot.create(:user)
    FactoryBot.create(:user_service_identifier, customer:, user:,
                                                identifier: 'victor.carvalho@ministrybrands.com')
    user
  end

  let(:project) do
    FactoryBot.create(:project, customer:,
                                metadata: { azure_project_name: '1ES', area_path: '1ES\\DDC UI Refresh\\2023' })
  end

  describe '#call' do
    it 'creates a list of issues' do
      VCR.use_cassette('clients#tts#azure#issue#list') do
        user
        expect do
          IssuesCreator.call(project)
        end.to change(Issue, :count).by(40)
      end
    end
  end
end
