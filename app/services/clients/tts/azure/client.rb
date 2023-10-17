# frozen_string_literal: true

module Clients
  module Tts
    module Azure
      class Client
        attr_reader :customer, :project

        BASE_URL = 'https://dev.azure.com/'

        def initialize(project)
          @project = project
          @customer = project.customer
        end

        def customer_url
          "#{BASE_URL}#{customer.name.downcase.gsub(' ', '')}"
        end

        def customer_authorization
          "Basic #{customer.ticket_tracking_system_token}"
        end
      end
    end
  end
end
