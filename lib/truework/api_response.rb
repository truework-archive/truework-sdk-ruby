# frozen_string_literal: true

module Truework
  class APIResponse
    attr_reader :url
    attr_reader :status_code
    attr_reader :body
    attr_reader :api_version

    def initialize(url, status_code, http_body: '', api_version: nil, **_params)
      @url = url
      @status_code = status_code
      @body = http_body
      @api_version = api_version
    end

    def self.extract_version(response)
      response.each_header.to_h['version']
    end

    def self.from_response(response)
      new(
        response.uri,
        response.code.to_i,
        http_body: response.body,
        api_version: extract_version(response)
      )
    end

    def json
      @json ||= JSON.parse(@body, symbolize_names: true) if @body && @body.strip != ''
    end
  end
end
