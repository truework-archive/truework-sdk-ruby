# frozen_string_literal: true

require 'truework/http_request'
require 'truework/api_response'

module Truework
  module APIOperations
    module Create
      include Truework::HTTPRequest

      def create(params)
        response = request(:post, resource_path, params)
        api_response = Truework::APIResponse.from_response(response)
        new(**api_response.json)
      end
    end
  end
end
