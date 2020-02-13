# frozen_string_literal: true

require 'truework/resources/address'

module Truework
  class Employer < APIResource
    attribute :name, Types::String
    attribute? :address, Truework::Address
  end
end
