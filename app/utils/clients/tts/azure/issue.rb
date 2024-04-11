# frozen_string_literal: true

module Clients
  module Tts
    module Azure
      class Issue < Client
        def list
          work_items = issues_urls.map do |url|
            url_expansion = "#{url}?api-version=6.0&$expand=relations"
            attempts = 0

            begin
              response = ::Request.get(url_expansion, customer_authorization)
            rescue StandardError => e
              attempts += 1
              retry if attempts < 5
              raise "Failed to get response for URL #{url} after 5 attempts: #{e.message}"
            end

            response
          end

          parsed_items = work_items.map do |work_item|
            parser.new(work_item, project)
          end

          filtered_items(parsed_items)
        end

        def filtered_items(parsed_items)
          parsed_items
        end

        def parser
          Object.const_get("Clients::Tts::Azure::Parsers::#{customer.name.split.map(&:capitalize).join}Parser")
        end

        def url
          "#{customer_url}/#{project_name}/_apis/wit/wiql?api-version=6.0"
        end

        def body(area_path)
          {
            'query' => 'SELECT [System.Id], [System.Title], [System.WorkItemType], [System.BoardColumn] ' \
                       'FROM workitems ' \
                       "WHERE [System.TeamProject] = '#{project_name}' AND [System.AreaPath] = '#{area_path}'"
          }
        end

        def issues_urls
          area_paths = project.metadata['area_paths']
          area_paths.map do |area_path|
            issues_list = ::Request.post(url, customer_authorization, body(area_path))
            issues_list['workItems'].pluck('url')
          end.flatten
        end

        def project_name
          project.metadata['azure_project_name']
        end
      end
    end
  end
end
