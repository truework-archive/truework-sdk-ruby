# frozen_string_literal: true

module Truework
  class APIResource < Dry::Struct
    transform_keys(&:to_sym)

    def self.convert_to_truework_object(data)
      case data
      when Array
        data.map { |x| convert_to_truework_object(x) }
      when Hash
        new(data)
      else
        data
      end
    end

    def self.resource_path
      raise NotImplementedError
    end
  end
end
