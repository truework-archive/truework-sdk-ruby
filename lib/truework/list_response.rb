# frozen_string_literal: true

require 'truework/api_response'

module Truework
  class ListResponse < APIResponse
    attr_reader :data

    def initialize(url, status_code, http_body: '', api_version: nil, klass: Truework::APIResource)
      super
      results = json && json[:results]
      @data = klass.convert_to_truework_object(results) if results
    end

    def self.from_response(response, klass: Truework::APIResource)
      new(
        response.uri,
        response.code.to_i,
        http_body: response.body,
        api_version: extract_version(response),
        klass: klass
      )
    end

    def num_results
      json && json[:count]
    end

    def next_url
      json && json[:next]
    end
  end
end
