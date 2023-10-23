# frozen_string_literal: true

module Clients
  module Tts
    module Asana
      module Parsers
        class TaylorSummitParser
          attr_reader :json, :project

          def initialize(json, project, asana_users)
            @json = json
            @project = project
            @asana_users = asana_users
          end

          def effort
            json.dig('data', 'custom_fields').find { |field| field['name'] == 'Story Points' }['number_value']
          end

          def user
            assignee = json.dig('data', 'assignee')
            return nil if assignee.nil?

            user_id = assignee['gid']
            asana_user = @asana_users.find { |user| user.dig('data', 'gid') == user_id }
            email = asana_user.dig('data', 'email')
            User.by_external_identifier(email).first
          end

          def state
            'Done'
          end

          def closed_date
            @json.dig('data', 'completed_at')
          end
        end
      end
    end
  end
end
