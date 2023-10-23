# frozen_string_literal: true

module Clients
  module Tts
    module Asana
      module Parsers
        class MyCareParser
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
            user_id = json.dig('data', 'assignee', 'gid')
            asana_user = @asana_users.find { |asana_user| asana_user.dig('data', 'gid') == user_id }
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
