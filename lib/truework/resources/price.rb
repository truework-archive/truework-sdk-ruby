# frozen_string_literal: true

module Truework
  class Price < APIResource
    attribute :amount, Types::JSON::Decimal
    attribute :currency, Types::String
  end
end
