# frozen_string_literal: true

module Truework
  class Company < APIResource
    extend APIOperations::List

    attribute :name, Types::String
    attribute? :id, Types::Integer
    attribute? :domain, Types::String

    def self.resource_path
      '/companies/'
    end
  end
end
