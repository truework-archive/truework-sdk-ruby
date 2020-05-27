# frozen_string_literal: true

require 'truework/http_request'
require 'truework/api_response'

module Truework
  module APIOperations
    module Cancel
      include Truework::HTTPRequest

      def instance_url(id)
        "#{resource_path}#{id}/"
      end

      def cancel(id, params)
        url = "#{instance_url(id)}cancel/"
        response = request(:put, url, params)
        api_response = Truework::APIResponse.from_response(response)
        new(**api_response.json)
      end
    end
  end
end
