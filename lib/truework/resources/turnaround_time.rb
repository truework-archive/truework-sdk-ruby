# frozen_string_literal: true

module Truework
  class TurnaroundTime < APIResource
    attribute? :upper_bound, Types::Params::Integer
    attribute? :lower_bound, Types::Params::Integer
  end
end
