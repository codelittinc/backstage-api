# frozen_string_literal: true

module Clients
  module Tts
    module Asana
      class Issue < Client
        def list
          issues_list = ::Request.get(list_url, customer_authorization)
          ids = issues_list['data'].pluck('gid')
          work_items = ids.map do |id|
            ::Request.get(project_url(id), customer_authorization)
          end

          asana_user_ids = work_items.map do |work_item|
            work_item.dig('data', 'assignee', 'gid')
          end.uniq.compact

          asana_users = asana_user_ids.map do |id|
            ::Request.get(user_url(id), customer_authorization)
          end

          work_items.map do |work_item|
            parser.new(work_item, project, asana_users) if work_item.dig('data', 'completed')
          end.compact
        end

        def list_url
          "#{BASE_URL}/projects/#{project_id}/tasks"
        end

        def project_url(gid)
          "#{BASE_URL}/tasks/#{gid}"
        end

        def user_url(gid)
          "#{BASE_URL}/users/#{gid}"
        end

        def project_id
          project.metadata['project_id']
        end

        def project_name
          project.metadata['azure_project_name']
        end
      end
    end
  end
end
