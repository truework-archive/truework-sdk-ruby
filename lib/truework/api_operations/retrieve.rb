# frozen_string_literal: true

require 'truework/http_request'
require 'truework/api_response'

module Truework
  module APIOperations
    module Retrieve
      include Truework::HTTPRequest

      def instance_url(id)
        "#{resource_path}#{id}/"
      end

      def retrieve(id)
        response = request(:get, instance_url(id))
        api_response = Truework::APIResponse.from_response(response)
        new(**api_response.json)
      end
    end
  end
end
