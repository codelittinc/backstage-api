# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Clients::Tts::Azure::Issue, type: :service do
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

  it 'defines the correct URL' do
    url = Clients::Tts::Azure::Issue.new(project).url
    expect(url).to eq('https://dev.azure.com/ministrybrands/1ES/_apis/wit/wiql?api-version=6.0')
  end

  describe '#list' do
    it 'finds the correct parter' do
      client = Clients::Tts::Azure::Issue.new(project)
      expect(client.parser).to be(Clients::Tts::Azure::Parsers::MinistryBrandsParser)
    end

    it 'returns a list of issues properly parsed' do
      VCR.use_cassette('clients#tts#azure#issue#list') do
        user
        result = Clients::Tts::Azure::Issue.new(project).list
        work_item = result.first

        expect(work_item.effort).to eql(8)
        expect(work_item.user).to eql(user)
        expect(work_item.state).to eql('Done')
        expect(work_item.closed_date).to eql('2023-09-06T14:06:51.537Z')
      end
    end
  end
end
