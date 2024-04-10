# frozen_string_literal: true

require 'rails_helper'

RSpec.describe IssuesCreator, type: :service do
  describe '#call' do
    context 'when the customer uses Azure DevOps' do
      let(:customer) do
        create(:customer, name: 'Ministry Brands', ticket_tracking_system_token: 'your-real-token-here',
                          ticket_tracking_system: 'azure')
      end

      let(:user) do
        user = create(:user)
        create(:user_service_identifier, customer:, user:,
                                         identifier: 'victor.carvalho@ministrybrands.com')
        user
      end

      let(:project) do
        create(:project, customer:,
                         metadata: { azure_project_name: '1ES', area_path: '1ES\\DDC UI Refresh\\2023' })
      end

      it 'creates a list of issues' do
        VCR.use_cassette('clients#tts#azure#issue#list') do
          user
          expect do
            IssuesCreator.call(project)
          end.to change(Issue, :count).by(1206)
        end
      end

      it 'sets the issue types correctly' do
        VCR.use_cassette('clients#tts#azure#issue#list') do
          user
          issues = IssuesCreator.call(project)
          feature = issues.find { |issue| issue.tts_id == '163794' }
          expect(feature.issue_type).to eq('feature')
          pbi = issues.find { |issue| issue.tts_id == '168900' }
          expect(pbi.issue_type).to eq('PBI')
          task = issues.find { |issue| issue.tts_id == '169223' }
          expect(task.issue_type).to eq('task')
          bug = issues.find { |issue| issue.tts_id == '168646' }
          expect(bug.bug).to be_truthy
        end
      end

      it 'sets the parent correctly' do
        VCR.use_cassette('clients#tts#azure#issue#list') do
          user
          issues = IssuesCreator.call(project)
          feature = issues.find { |issue| issue.tts_id == '168900' }
          expect(feature.parent_tts_id).to eq('163794')
        end
      end

      it 'ignores the issues that are not valid' do
        VCR.use_cassette('clients#tts#azure#issue#list') do
          user
          issues = IssuesCreator.call(project)
          issue_should_be_ignored = issues.find { |issue| issue.tts_id == '169068' }
          expect(issue_should_be_ignored).to be_nil
        end
      end
    end

    context 'when the customer uses Asana' do
      let(:customer) do
        create(:customer, name: 'Taylor Summit',
                          ticket_tracking_system_token: 'my-cool-key',
                          ticket_tracking_system: 'asana')
      end

      let(:user) do
        create(:user, email: 'albo.vieira@codelitt.com')
      end

      let(:project) do
        create(:project, customer:, metadata: { project_id: '1205173534425434' })
      end

      it 'creates a list of issues' do
        VCR.use_cassette('clients#tts#asana#issue#list') do
          user
          expect do
            IssuesCreator.call(project)
          end.to change(Issue, :count).by(174)
        end
      end
    end
  end
end
