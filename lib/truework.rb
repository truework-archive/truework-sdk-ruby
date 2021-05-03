# frozen_string_literal: true

require 'dry-struct'
require 'json'

require 'truework/version'
require 'truework/api_response'
require 'truework/api_resource'
require 'truework/api_operations/create'
require 'truework/api_operations/cancel'
require 'truework/api_operations/list'
require 'truework/api_operations/retrieve'
require 'truework/types'
require 'truework/resources'
require 'truework/environment'

module Truework
  DEFAULT_CA_BUNDLE_PATH = "#{__dir__}/truework/data/ca-certificates.crt"
  PRODUCTION_URL = 'https://api.truework.com'
  SANDBOX_URL = 'https://api.truework-sandbox.com'

  @ca_bundle_path = DEFAULT_CA_BUNDLE_PATH
  @ca_store = nil

  class << self
    attr_reader :api_base
    attr_reader :api_key
    attr_reader :api_version

    def configure(api_key, api_version: nil, environment: nil, api_base: nil)
      @api_key = api_key
      @api_version = api_version

      if environment && api_base
        raise ClientException, "Cannot configure client with both environment and api_base defined"
      elsif api_base
        @api_base = api_base
      elsif environment == Environment::SANDBOX
        @api_base = SANDBOX_URL
      else
        @api_base = PRODUCTION_URL
      end
    end
  end
end
