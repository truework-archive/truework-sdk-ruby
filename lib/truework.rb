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

module Truework
  DEFAULT_CA_BUNDLE_PATH = "#{__dir__}/truework/data/ca-certificates.crt"

  @api_base = 'https://api.truework.com'
  @api_version = nil

  @ca_bundle_path = DEFAULT_CA_BUNDLE_PATH
  @ca_store = nil

  class << self
    attr_accessor :api_base
    attr_accessor :api_key
    attr_accessor :api_version
  end
end
