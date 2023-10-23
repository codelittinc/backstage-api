# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CreateIssuesTask, type: :task do
  describe '#create!' do
    it 'calls the issue creator for the projects that are active and have a ticket_tracking_system_token' do
      customer_azure = FactoryBot.create(:customer, ticket_tracking_system_token: 'place-real-token-here',
                                                    ticket_tracking_system: 'azure')
      FactoryBot.create(:customer, ticket_tracking_system_token: 'place-real-token-here',
                                   ticket_tracking_system: 'asana')

      project_azure = FactoryBot.create(:project, customer: customer_azure,
                                                  start_date: Time.zone.today - 1,
                                                  end_date: Time.zone.today + 1)

      project_asana = FactoryBot.create(:project, customer: customer_azure,
                                                  start_date: Time.zone.today - 1,
                                                  end_date: Time.zone.today + 1)

      expect(IssuesCreator).to receive(:call).with(project_azure)
      expect(IssuesCreator).to receive(:call).with(project_asana)

      CreateIssuesTask.create!
    end

    it 'does not call the issue creator for the projects that are not active' do
      customer_azure = FactoryBot.create(:customer, ticket_tracking_system_token: 'place-real-token-here',
                                                    ticket_tracking_system: 'azure')
      FactoryBot.create(:customer, ticket_tracking_system_token: 'place-real-token-here',
                                   ticket_tracking_system: 'asana')
      project_azure = FactoryBot.create(:project, customer: customer_azure,
                                                  start_date: Time.zone.today - 1,
                                                  end_date: Time.zone.today - 1)

      project_asana = FactoryBot.create(:project, customer: customer_azure,
                                                  start_date: Time.zone.today + 1,
                                                  end_date: Time.zone.today + 1)

      expect(IssuesCreator).not_to receive(:call).with(project_azure)
      expect(IssuesCreator).not_to receive(:call).with(project_asana)

      CreateIssuesTask.create!
    end

    it 'does not call the issue creator for the customers that do not have the ticket_tracking_system_token set' do
      customer_azure = FactoryBot.create(:customer, ticket_tracking_system_token: nil)
      FactoryBot.create(:customer, ticket_tracking_system_token: nil)
      project_azure = FactoryBot.create(:project, customer: customer_azure,
                                                  start_date: Time.zone.today - 1,
                                                  end_date: Time.zone.today + 1)

      project_asana = FactoryBot.create(:project, customer: customer_azure,
                                                  start_date: Time.zone.today - 1,
                                                  end_date: Time.zone.today + 1)

      expect(IssuesCreator).not_to receive(:call).with(project_azure)
      expect(IssuesCreator).not_to receive(:call).with(project_asana)

      CreateIssuesTask.create!
    end

    it 'does not call the issue creator for the customers that do not have the ticket_tracking_system set' do
      customer_azure = FactoryBot.create(:customer, ticket_tracking_system_token: 'place-real-token-here',
                                                    ticket_tracking_system: nil)
      FactoryBot.create(:customer, ticket_tracking_system_token: 'place-real-token-here',
                                   ticket_tracking_system: nil)
      project_azure = FactoryBot.create(:project, customer: customer_azure,
                                                  start_date: Time.zone.today - 1,
                                                  end_date: Time.zone.today + 1)

      project_asana = FactoryBot.create(:project, customer: customer_azure,
                                                  start_date: Time.zone.today - 1,
                                                  end_date: Time.zone.today + 1)

      expect(IssuesCreator).not_to receive(:call).with(project_azure)
      expect(IssuesCreator).not_to receive(:call).with(project_asana)

      CreateIssuesTask.create!
    end
  end
end
