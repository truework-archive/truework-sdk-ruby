# frozen_string_literal: true

module Truework
  class Position < APIResource
    attribute :title, Types::String
    attribute :start_date, Types::JSON::Date
    attribute? :end_date, Types::JSON::Date
  end
end
