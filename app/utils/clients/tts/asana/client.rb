# frozen_string_literal: true

module Clients
  module Tts
    module Asana
      class Client
        attr_reader :customer, :project

        BASE_URL = 'https://app.asana.com/api/1.0'

        def initialize(project)
          @project = project
          @customer = project.customer
        end

        def customer_url
          BASE_URL
        end

        def parser
          Object.const_get("Clients::Tts::Asana::Parsers::#{customer.name.split.map(&:capitalize).join}Parser")
        end

        def customer_authorization
          "Bearer #{customer.ticket_tracking_system_token}"
        end
      end
    end
  end
end
