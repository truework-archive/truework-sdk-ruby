# frozen_string_literal: true

module Truework
  class Earnings < APIResource
    attribute :year, Types::Coercible::Integer
    attribute :base, Types::JSON::Decimal
    attribute :overtime, Types::JSON::Decimal
    attribute :commission, Types::JSON::Decimal
    attribute :bonus, Types::JSON::Decimal
    attribute :total, Types::JSON::Decimal
  end
end
