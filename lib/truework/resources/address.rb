# frozen_string_literal: true

module Truework
  class Address < APIResource
    attribute? :line_one, Types::String
    attribute? :line_two, Types::String
    attribute? :city, Types::String
    attribute? :state, Types::String
    attribute? :country, Types::String
    attribute? :postal_code, Types::String
  end
end
