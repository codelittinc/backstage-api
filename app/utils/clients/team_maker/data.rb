# frozen_string_literal: true

module Clients
  module TeamMaker
    class Data < Client
      def list(backstage_id)
        data = ::Request.get("#{BASE_URL}/data/index?backstage_project_id=#{backstage_id}")
        # rubocop:disable Style/OpenStructUse
        JSON.parse(data.to_json, object_class: OpenStruct)
        # rubocop:enable Style/OpenStructUse
      end
    end
  end
end
