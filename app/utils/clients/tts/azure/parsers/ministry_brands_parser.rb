# frozen_string_literal: true

module Clients
  module Tts
    module Azure
      module Parsers
        class MinistryBrandsParser
          attr_reader :json, :project, :iterations

          def initialize(json, project, iterations)
            @json = json
            @project = project
            @iterations = iterations
          end

          def valid?
            !title.match?(/\[QA\]/i)
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
            work_item_type = json.dig('fields', 'System.WorkItemType')

            work_item_type.downcase.gsub(' ', '_')
          end

          def reported_at
            json.dig('fields', 'System.CreatedDate')
          end

          def tts_id
            json['id'].to_s
          end

          def bug?
            title.match?(/.*Bug.*/i)
          end

          def parent_tts_id
            json.dig('fields', 'System.Parent')
          end

          def board_column
            json.dig('fields', 'System.BoardColumn')
          end

          def sprint
            json.dig('fields', 'System.IterationPath')
          end
        end
      end
    end
  end
end
