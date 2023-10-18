# frozen_string_literal: true

module Clients
  module Tts
    module Azure
      class Issue < Client
        def list
          issues_list = ::Request.post(url, customer_authorization, body)
          urls = issues_list['workItems'].pluck('url')
          work_items = urls.map { |url| ::Request.get(url, customer_authorization) }
          work_items.map do |work_item|
            parser.new(work_item, project)
          end
        end

        def parser
          Object.const_get("Clients::Tts::Azure::Parsers::#{customer.name.split.map(&:capitalize).join}Parser")
        end

        def url
          "#{customer_url}/#{project_name}/_apis/wit/wiql?api-version=6.0"
        end

        def body
          area_path = project.metadata['area_path']

          {
            'query' => 'SELECT [System.Id], [System.Title], [System.WorkItemType], [System.BoardColumn] ' \
                       'FROM workitems ' \
                       "WHERE [System.TeamProject] = '#{project_name}' AND [System.AreaPath] = '#{area_path}'"
          }
        end

        def project_name
          project.metadata['azure_project_name']
        end
      end
    end
  end
end
