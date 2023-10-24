# frozen_string_literal: true

module Clients
  module Tts
    module Azure
      module Parsers
        class MinistryBrandsParser
          attr_reader :json, :project

          def initialize(json, project)
            @json = json
            @project = project
          end

          def effort
            json['fields']['Microsoft.VSTS.Scheduling.Effort']&.to_i
          end

          def user
            identifier = json.dig('fields', 'System.AssignedTo', 'uniqueName')
            User.by_external_identifier(identifier).first
          end

          def state
            json['fields']['System.State']
          end

          def closed_date
            json['fields']['Microsoft.VSTS.Common.ClosedDate']
          end

          def title
            json.dig('fields', 'System.Title')
          end

          def issue_type
            return 'Bug' if title.match?(/.*Bug.*/i)
            return 'Product Backlog Item' if json.dig('fields', 'System.WorkItemType') == 'Product Backlog Item'

            'Task'
          end

          def issue_id
            json['id'].to_s
          end
        end
      end
    end
  end
end
