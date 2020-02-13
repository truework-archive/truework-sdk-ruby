# frozen_string_literal: true

require 'truework/http_request'
require 'truework/list_response'

module Truework
  module APIOperations
    module List
      include Truework::HTTPRequest

      def list(params = {})
        response = request(:get, resource_path, params)
        Truework::ListResponse.from_response(response, klass: self)
      end
    end
  end
end
