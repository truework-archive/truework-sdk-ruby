# frozen_string_literal: true

require 'net/https'
require 'uri'
require 'json'
require 'openssl'

require 'truework/exceptions'

module Truework
  module HTTPRequest
    def get(path, params = {})
      request(:get, path, params)
    end

    def post(path, params = {})
      request(:post, path, params)
    end

    def put(path, params = {})
      request(:put, path, params)
    end

    def delete(path, params = {})
      request(:delete, path, params)
    end

    def request(method, path, params = {})
      uri = URI.parse("#{Truework.api_base}#{path}")

      request = build_request(method, uri, params)
      http = Net::HTTP.new(uri.host, uri.port)

      if uri.scheme == 'https'
        http.use_ssl = true
        http.ca_file = Truework::DEFAULT_CA_BUNDLE_PATH
      end

      response = http.request(request)
      handle_errors(response)
      response
    end

    private

    def handle_errors(response)
      case response
      when Net::HTTPSuccess
        response
      else
        EXCEPTION_MAP.each do |response_class, exception_class|
          raise exception_class, error_message_from_response(response) if response.is_a?(response_class)
        end

        raise Truework::UnexpectedHTTPException, "#{response.code} #{response.body}"
      end
    end

    EXCEPTION_MAP = {
      Net::HTTPUnauthorized => Truework::InvalidCredentials,
      Net::HTTPNotFound => Truework::NonExistentRecord,
      Net::HTTPConflict => Truework::RecordAlreadyExists,
      Net::HTTPBadRequest => Truework::BadRequest,
      Net::HTTPForbidden => Truework::Forbidden,
      Net::HTTPInternalServerError => Truework::InternalServerError,
      Net::HTTPBadGateway => Truework::BadGateway,
      Net::HTTPServiceUnavailable => Truework::ServiceUnavailable,
      Net::HTTPGatewayTimeOut => Truework::GatewayTimeout
    }.freeze

    def error_message_from_response(response)
      body = response.body
      json = JSON.parse(body) if body && body.strip != ''
      return json['error'] if json&.key?('error')

      body
    rescue JSON::ParserError
      body
    end

    # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength, Metrics/PerceivedComplexity
    def build_request(method, uri, params)
      klass = case method
              when :get
                Net::HTTP::Get
              when :post
                Net::HTTP::Post
              when :put
                Net::HTTP::Put
              when :delete
                Net::HTTP::Delete
              end

      case method
      when :get, :delete
        uri.query = URI.encode_www_form(params) if params && !params.empty?
        req = klass.new(uri.request_uri)
      when :post, :put
        req = klass.new(uri.request_uri)
        req.body = JSON.generate(params) unless params.empty?
      end

      req['Content-Type'] = 'application/json'
      req['Accept'] = "application/json#{"; version=#{Truework.api_version}" if Truework.api_version}"
      req['User-Agent'] = "Truework Ruby SDK #{Truework::VERSION};"\
                          "#{RUBY_PLATFORM};#{RUBY_ENGINE};#{RUBY_VERSION} p#{RUBY_PATCHLEVEL}"
      req['Authorization'] = "Bearer #{Truework.api_key}"

      req
    end
    # rubocop:enable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength, Metrics/PerceivedComplexity
  end
end
