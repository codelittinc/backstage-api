# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Clients::Tts::Asana::Issue, type: :service do
  let(:customer) do
    create(:customer, name: 'Taylor Summit',
                      ticket_tracking_system_token: 'my-cool-key')
  end

  let(:user) do
    create(:user, email: 'albo.vieira@codelitt.com')
  end

  let(:project) do
    create(:project, customer:, metadata: { project_id: '1205173534425434' })
  end

  describe '#list' do
    it 'finds the correct parser' do
      client = Clients::Tts::Asana::Issue.new(project)
      expect(client.parser).to be(Clients::Tts::Asana::Parsers::TaylorSummitParser)
    end

    it 'returns a list of issues properly parsed' do
      VCR.use_cassette('clients#tts#asana#issue#list') do
        user
        result = Clients::Tts::Asana::Issue.new(project).list
        task = result.first

        expect(task.effort).to eql(2)
        expect(task.user).to eql(user)
        expect(task.state).to eql('Done')
        expect(task.closed_date).to eql('2023-10-23T15:09:20.385Z')
      end
    end
  end
end
